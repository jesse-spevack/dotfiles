---
name: gce-oauth-scopes-vs-iam-roles
description: |
  Fix "Request had insufficient authentication scopes" (ACCESS_TOKEN_SCOPE_INSUFFICIENT)
  errors when calling Google Cloud APIs from Docker containers on GCE VMs. Use when:
  (1) IAM role is correctly granted but API calls fail with 403, (2) error mentions
  "insufficient authentication scopes" not "permission denied", (3) application runs
  in a Docker container on a GCE VM using default compute service account. Root cause:
  VM OAuth scopes are separate from IAM roles and must include the API's scope.
author: Claude Code
version: 1.0.0
date: 2026-03-15
---

# GCE OAuth Scopes vs IAM Roles

## Problem
Google Cloud API calls from Docker containers on GCE VMs fail with 403 `ACCESS_TOKEN_SCOPE_INSUFFICIENT` even though the service account has the correct IAM role. This happens because GCE VMs have two independent authorization layers: IAM roles (what the SA is allowed to do) and OAuth scopes (what tokens the VM can request).

## Context / Trigger Conditions
- Application runs in a Docker container on a GCE VM
- Uses Application Default Credentials (metadata server) for auth
- IAM role is correctly assigned (e.g., `roles/aiplatform.user`)
- API calls fail with:
  ```json
  {
    "error": {
      "code": 403,
      "message": "Request had insufficient authentication scopes.",
      "status": "PERMISSION_DENIED",
      "details": [{"reason": "ACCESS_TOKEN_SCOPE_INSUFFICIENT"}]
    }
  }
  ```
- Key distinction: error says "authentication **scopes**" not "permission denied" — this points to VM scopes, not IAM

## Solution

### 1. Check current VM scopes
```bash
gcloud compute instances describe VM_NAME --zone=ZONE --format="value(serviceAccounts.scopes)"
```
If the output shows narrow scopes (e.g., `devstorage.read_only`, `logging.write`) without `cloud-platform`, that's the problem.

### 2. Fix: Update VM scopes (requires stop/start)
```bash
gcloud compute instances stop VM_NAME --zone=ZONE --project=PROJECT
gcloud compute instances set-service-account VM_NAME --zone=ZONE --project=PROJECT \
  --scopes=cloud-platform
gcloud compute instances start VM_NAME --zone=ZONE --project=PROJECT
```

### 3. No redeploy needed
The scope change applies to the VM's metadata server. Docker containers query the metadata server at runtime for tokens, so existing containers will get properly-scoped tokens after the VM restarts.

## Verification
After VM restart:
```bash
# Check scopes are updated
gcloud compute instances describe VM_NAME --zone=ZONE --format="value(serviceAccounts.scopes)"
# Should show: ['https://www.googleapis.com/auth/cloud-platform']

# Test API call from container
docker exec CONTAINER bin/rails runner "puts EmbeddingService.call('test').length"
```

## Example
In js-notes, the VM `js-notes` was created with default narrow scopes. After granting `roles/aiplatform.user` to the default compute SA, Vertex AI embedding calls still failed with `ACCESS_TOKEN_SCOPE_INSUFFICIENT`. Fixed by stopping the VM and setting `--scopes=cloud-platform`.

## Notes
- **`cloud-platform` is the broadest scope** — it covers all GCP APIs. IAM roles still control actual permissions, so this is safe.
- **VMs created via Console** often get narrow scopes by default. VMs created programmatically may vary.
- **No hot-reload**: VM must be stopped to change scopes. This causes brief downtime.
- **Docker containers access metadata server** at `http://169.254.169.254` — GCE configures iptables rules for this automatically, even from Docker bridge networks.
- The `googleauth` Ruby gem's `Google::Auth.get_application_default` uses this metadata server on GCE.

## References
- https://cloud.google.com/compute/docs/access/create-enable-service-accounts-for-instances#changeserviceaccountandscopes
- https://cloud.google.com/compute/docs/access/service-accounts#accesscopesiam

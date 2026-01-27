---
description: Review a PR with structured findings and iteration support
argument-hint: [pr-number-or-branch]
---

# Review Command

Review a pull request, producing structured findings that can be acted upon.

## Input

PR number, branch name, or leave blank for current branch: $ARGUMENTS

## Process

### 1. Identify What to Review

```bash
# If PR number given
gh pr view $ARGUMENTS --json number,title,body,baseRefName,headRefName

# If branch name or blank, find associated PR
gh pr list --head $(git branch --show-current) --json number,title
```

Get the diff:
```bash
gh pr diff $PR_NUMBER
```

### 2. Produce Summary

Write a brief summary (3-5 bullet points) covering:
- What this PR does (the "what")
- Why it matters (the "why" if evident from PR description)
- Scope of changes (files touched, rough size)

### 3. First-Pass Review (Optional)

If this is a first-pass review (Claude reviewing before user), scan for:

**Critical issues** (must fix before merge):
- Security vulnerabilities
- Data loss risks
- Breaking changes without migration

**Concerns** (should address):
- Missing error handling
- Performance problems (N+1, etc.)
- Test coverage gaps
- Logic errors

**Suggestions** (consider improving):
- Code clarity
- Naming
- Patterns that could be cleaner

### 4. Create Finding Beads

For each finding, create a bead:

```bash
bd create --title="[Brief description of issue]" --type=bug --priority=X \
  --description="**Location:** file:line

**Issue:** What's wrong

**Proposed fix:** How to address it

**Pros:** Why this fix is good
**Cons:** Tradeoffs or risks

**Triage:** [blocking | fast-follow]"
```

- **blocking** = Must fix on this branch before merge
- **fast-follow** = Can merge, but create separate PR soon

### 5. Interactive Review Mode

After creating finding beads, offer interactive review:

"I found X issues. Want to walk through them one at a time?"

For each finding:
1. Present the finding with location, issue, and proposed fix
2. Ask: **"Fix it / Skip / Disagree / Fast-follow?"**
   - **Fix it** - Apply the fix now
   - **Skip** - Move to next finding without action
   - **Disagree** - Mark for user review with reason
   - **Fast-follow** - Mark as non-blocking, move on

### 6. Handle Disagreements

When implementor (or Claude in first-pass) marks a finding as "disagree":

```bash
bd update <finding-id> --notes="DISAGREEMENT: [reason given]"
```

At the end of review, list all disagreements:

"These findings were disputed and need your decision:
- beads-xxx: [finding summary] - Disagreement: [reason]
- beads-yyy: [finding summary] - Disagreement: [reason]"

### 7. Chunk-by-Chunk Review (For Large PRs)

For PRs with many files, offer to review by logical chunks:

"This PR touches 15 files across 3 areas:
1. Authentication (4 files)
2. API endpoints (6 files)
3. Tests (5 files)

Want to review chunk by chunk?"

If yes, review one chunk at a time, creating findings as you go.

### 8. Completion

When review is done:

```bash
bd list --status=open  # Show remaining findings
```

Summarize:
- Total findings: X
- Blocking: Y (must fix before merge)
- Fast-follow: Z (can merge, fix later)
- Disagreements: W (need user decision)

If all blocking issues are resolved:
"PR is ready to merge. Fast-follows tracked in beads for follow-up."

## Key Principles

- **Findings become beads** - Everything is tracked, nothing lost
- **Triage matters** - Not everything blocks merge
- **Disagreements surface** - Don't blindly follow suggestions
- **Chunk by chunk** - Large PRs are reviewable in pieces
- **Summary first** - Quick overview before details

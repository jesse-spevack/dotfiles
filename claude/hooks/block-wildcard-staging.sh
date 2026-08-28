#!/usr/bin/env bash
# PreToolUse hook for Bash: refuse git commands that stage by wildcard.
input=$(cat)
command=$(printf '%s' "$input" | python3 -c 'import json,sys; print(json.load(sys.stdin).get("tool_input",{}).get("command",""))' 2>/dev/null || true)

if printf '%s' "$command" | grep -qE '(^|[;&|[:space:]])git[[:space:]]+(commit[[:space:]]+(-[a-zA-Z]*a[a-zA-Z]*|--all)|add[[:space:]]+(-A|--all|-[a-zA-Z]*A[a-zA-Z]*|\.([[:space:]]|$)))'; then
  echo "Blocked: wildcard staging (git commit -a, git add -A, git add .) is not allowed. Stage files by path." >&2
  exit 2
fi
exit 0

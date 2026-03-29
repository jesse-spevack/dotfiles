---
name: in-person-review
description: |
  Interactive code review that walks through a branch diff file-by-file, hunk-by-hunk.
  Mimics the GitHub PR review experience in the terminal. Use when Jesse wants to
  review a PR or branch diff interactively — browsing code, asking questions, and
  giving feedback as he goes. Creates beads for findings and optionally applies fixes
  or generates a handoff prompt.
  Triggers: "/in-person-review", "let's walk through the diff", "review this branch with me"
author: Jesse + Claude
version: 1.0.0
date: 2026-02-15
tags: [review, workflow, interactive]
---

# In-Person Review

Interactive, human-in-the-loop code review. Jesse reviews, Claude assists.

## Setup

1. Identify the working repo and branch:
   - If in a worktree or repo with a feature branch checked out, use that
   - If Jesse specifies a repo path or PR number, use that
   - Default comparison: `git diff main...HEAD`

2. Get the file list:
   ```bash
   git diff main...HEAD --stat
   ```

3. Get the full diff, split by file:
   ```bash
   git diff main...HEAD
   ```

4. Parse the diff into files, then into hunks per file.

5. Present the review overview:
   ```
   ## Review: branch-name vs main

   X files changed, Y insertions, Z deletions

   Files:
   1. app/models/episode.rb (+5, -3)
   2. app/services/creates_url_episode.rb (+1, -1)
   3. test/models/episode_test.rb (+20, -4)
   ...

   Starting with file 1. Say "skip" to jump to a specific file or "list" to see files again.
   ```

## Per-File Flow

For each changed file:

### Step 1: Full File Context

Show the **complete current state** of the file (after changes) using the Read tool.
This gives Jesse the full picture before diving into individual changes.

Say:
```
## File 1/X: path/to/file.rb

Here's the full file as it stands now. When you're ready, I'll walk through
the N hunks of changes. Say "next" to start, or ask any questions about the file.
```

Wait for Jesse's response. He may:
- Ask a question about the file generally
- Give file-level feedback
- Say "next" / "go" to start hunk review
- Say "skip" to move to the next file

### Step 2: Hunk-by-Hunk Review

For each hunk, show **before and after** states clearly:

```
### Hunk 1/N — lines 65-72

**Before:**
```ruby
      status: :processing
```

**After:**
```ruby
      status: :pending
```
```

Use enough surrounding context (3-5 lines) so the change makes sense.
For small hunks, show more context. For large hunks, show the full hunk.

After presenting each hunk, wait for Jesse's response.

## Handling Feedback

Jesse's responses fall into these categories:

### Question
Jesse asks about the code (e.g., "why did this change?", "what calls this?")
- Answer the question using codebase knowledge
- Stay on the same hunk — don't advance until Jesse says to move on

### Fix Request
Jesse identifies something that needs fixing (e.g., "rename this variable", "this should have a guard clause")
- Acknowledge the feedback
- Create a bead immediately:
  ```bash
  bd create --title="[brief description of fix]" --type=bug --priority=1
  bd update <id> --description="File: path/to/file.rb, lines X-Y. [Jesse's feedback]. Context: [relevant details]"
  ```
- Report the bead ID
- Continue to next hunk

### Change Request
Jesse wants a design-level change (e.g., "this belongs in a different service", "add a preparing status")
- Acknowledge and discuss if needed
- Create a bead with more context:
  ```bash
  bd create --title="[description of change]" --type=task --priority=1
  bd update <id> --description="[Full context including files affected, rationale, and any discussion]"
  ```
- If this affects upcoming hunks, note that

### Move On
Jesse says "next", "ok", "fine", "move on", thumbs up, or similar
- Advance to the next hunk (or next file if last hunk)

### Navigation
- "skip" or "next file" — jump to next file
- "back" — show previous hunk again
- "list" — show file list with progress
- "file N" — jump to specific file
- "full file" — re-show the complete current file

## Review Summary

After all files are reviewed (or Jesse says "done"):

```
## Review Summary

Reviewed X/Y files, created N findings:

1. [bead-id] — [title] (fix)
2. [bead-id] — [title] (change)
3. [bead-id] — [title] (fix)

What would you like to do?
- "fix" — Apply fixes now (if context capacity allows)
- "handoff" — Save state and generate handoff prompt
- "done" — Wrap up, findings are in beads
```

### If "fix" — Apply Fixes In-Session
- Work through beads in order
- For each: make the change, show Jesse, close the bead
- Run tests after all fixes
- Commit when Jesse approves

### If "handoff" — Save State for Next Session
1. Update the brief with review findings section
2. Ensure all beads have full context in descriptions
3. Generate a handoff prompt:
   ```
   Continue work on [branch] in [repo]. Run `bd ready` to see review findings
   from Jesse's in-person review. Apply fixes, run tests, and push.
   Read briefs/[brief].md for full context.
   ```

### If "done" — Clean Wrap
- Findings live in beads for later
- No immediate action needed

## Context Management

Track approximate context usage. If approaching limits:
- Warn Jesse: "Context is getting long. I'd recommend switching to handoff mode after this file."
- Don't wait until it's too late — suggest handoff proactively
- When generating handoff, include enough context in bead descriptions that a fresh session can act on them without the review conversation

## Tips

- Keep hunk presentations concise — Jesse is reading code, not prose
- Don't editorialize unless asked — this is Jesse's review, not Claude's
- If Jesse asks "what do you think?", give an honest technical opinion
- Track which files have been reviewed so "list" can show progress
- If a file is new (not a diff but entirely new), show the full file and walk through sections instead of hunks

---
name: thank-you-for-your-service
description: Session handoff - captures context and generates a continuation prompt for the next session
---

# Thank You For Your Service

Capture session context so the next session can pick up where you left off.

Optional context from user: `$ARGUMENTS`

## Step 1: Detect environment

```bash
ls .beads/ 2>/dev/null
git status
git branch --show-current
git log --oneline -5
```

| Marker | Workflow |
|--------|----------|
| `.beads/` exists | Update beads, then review |
| No `.beads/` | Skip to review |

## Step 2: Update beads

```bash
bd done <id>                            # Completed tasks
bd comments add <id> "Session: <summary>. Next: <what's needed>"
bd comments add <id> "Avoid: <dead ends as one-liners>"    # only if there are any
bd create "Title" -p <priority>         # Newly discovered work
```

Keep "Avoid:" as its own comment so future agents can scan for dead ends without reading full session summaries.

## Step 3: Review

Present a summary before finalizing:

```
Session handoff summary:

What was done:
- [accomplishment 1]
- [accomplishment 2]

What didn't work:
- [approach tried and why it failed]

Avoid next session:
- [concise "don't try X because Y" bullets, if any]

Current state:
- [where things stand]

Next steps:
- [what the next agent should do]

Look right?
```

Wait for confirmation. Fix anything flagged before proceeding.

## Step 4: Continuation prompt

Generate a copy-paste prompt for the next session. Populate `Avoid:` from the review's "Avoid next session" bullets. Omit the line entirely if there are none.

**With beads:**
```
Continue from previous session.
Run: bd show <id> for context

Summary: [one line - what's done, what's next]
Avoid: [dead ends from this session, if any]
```

**Bare:**
```
Continue from previous session in [repo] on branch [branch].
What's done: [one line]
What's next: [one line]
Avoid: [dead ends from this session, if any]
Key files: [2-3 most important paths]
```

## Output

```
Handoff complete.

Updated: [what was written - beads as applicable]

Continuation prompt (copy for next session):
---
[continuation prompt]
---
```

## Rules

- Does not commit or push. Handle that separately.
- Only include information with real content. No padding empty sections.
- Continuation prompts: 3-5 lines. The next session can dig deeper.
- Always show the review before writing.

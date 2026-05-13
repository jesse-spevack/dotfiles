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
| `.beads/` exists | Update beads, then output |
| No `.beads/` | Skip to output |

## Step 2: Update beads

```bash
bd close <id>                        # Completed tasks
bd note <id> "Session: <summary>. Next: <what's needed>"
bd note <id> "Avoid: <dead ends as one-liners>"    # only if there are any
bd create "Title" -p <priority>      # Newly discovered work
```

Keep "Avoid:" as its own note so future agents can scan for dead ends without reading full session summaries.

## Step 3: Generate output

No confirmation loop — produce the output in one pass.

**With beads:**
```
Continue from bd show <id>.
Avoid: [dead ends, if any]
```

**Bare:**
```
Continue from previous session in [repo] on branch [branch].
What's done: [one line]
What's next: [one line]
Avoid: [dead ends, if any]
Key files: [2-3 most important paths]
```

## Output

```
Handoff complete.

Done:
- [accomplishment 1]
- [accomplishment 2]

Next:
- [what the next agent should do]

Avoid:
- [dead ends, if any — omit section if none]

Continuation prompt (copy for next session):
---
[continuation prompt from Step 3]
---

Godspeed, next one.
```

## Rules

- Does not commit or push. Handle that separately.
- Only include sections with real content. No padding.
- Continuation prompts: 1-2 lines with beads, 3-5 lines bare.
- No back-and-forth. End with the output.

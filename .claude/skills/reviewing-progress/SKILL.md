---
name: reviewing-progress
description: Use when user shares a progress report from an execution session - dispatches progress-reviewer agent to compare against plan and generate prompts for course correction
---

# Reviewing Progress

Dispatch progress-reviewer agent to compare execution progress against the plan.

**Core principle:** The original session supervises; the execution session implements.

## When to Use

When the user shares a progress report from an execution session, invoke this skill to:
1. Compare progress against the plan
2. Identify deviations or concerns
3. Generate ready-to-use prompts for the execution session

## How to Review

**1. Gather context:**
- The original plan (should be in `docs/plans/`)
- The progress report (user provides)

**2. Dispatch progress-reviewer agent:**

Use Task tool with prompt:

```
Review this execution progress against the plan.

**Plan:** [path to plan or inline plan content]

**Progress Report:**
[paste the report from execution session]

Compare the completed work against the plan. Identify any deviations, quality gaps, or blockers. Generate ready-to-use prompts for the execution session to address any issues.
```

**3. Return results to user:**

The agent will provide:
- Progress assessment (on track / deviations / blocked)
- Concerns table
- Ready-to-paste prompts for the execution session
- Recommendation (continue / fix first / pause)

## User Workflow

```
Execution Session                    Original Session
       |                                    |
       | (executes batch)                   |
       |                                    |
       |----- progress report ------------->|
       |                                    |
       |                            [dispatches progress-reviewer]
       |                                    |
       |<---- prompts + recommendation -----|
       |                                    |
       | (applies prompts, continues)       |
       v                                    v
```

## Integration with writing-plans

After `writing-plans` creates a plan and hands off to an execution session, this skill handles all subsequent progress reviews until the plan is complete.

# Claude Workflow Preferences

These preferences apply globally to all projects.

## Git Workflow

- **Always work on branches, not main** - Create a feature branch before making changes
- **Create PRs at reviewable milestones** - Not one mega-PR at the end
- **Use semantic commits** - `feat:`, `fix:`, `refactor:`, etc.

## Tracking Work

- **Use beads for tracking, not markdown plans** - Plans as committed markdown create PR noise and get stale
- **Epic bead for features** - Store design decisions in `--design` field
- **Child beads for meaningful chunks** - 3-7 per feature, each could be a commit or handoff point
- **Update `--notes` as work progresses** - Capture implementation decisions
- **Use TodoWrite for atomic steps** - Within a single work session only

## Execution Style

- **Explain what you're doing and why, then act** - Don't ask permission for each step
- **Offer a ripcord** - "Say 'stop' if you want to change approach"
- **Be smart about parallelization** - Spin up subagents for independent work, sequential for dependencies
- **Sense when context is running low** - Proactively suggest handoff before it's a problem

## Reviews

- **First-pass review is optional** - Claude can catch obvious issues before user reviews
- **Findings become beads** - Each concern is a bead with proposed fix and pros/cons
- **Interactive review for details** - Walk through findings one at a time
- **Triage findings** - Most fix on same branch, some marked as fast-follow (don't block PR)
- **Flag disagreements** - If implementor disagrees with a finding, surface it to user for final call

## Handoffs

- **Same session, context available** - Auto-continue to next phase
- **New session needed** - Provide lightweight prompt with mode and epic reference
- **Context lives in beads** - The prompt just says what mode to enter, beads have the details
- **Triggers for new session**:
  - Context is getting long/compacted
  - User explicitly asks
  - Work pattern needs fresh orchestrator (parallel subagents)

## Example Handoff Prompt

```
Continue implementing beads under epic beads-xxx. Enter orchestrator mode -- spin up subagents for ready tasks.
```

The new session runs `bd show <epic>` for design context and `bd ready` for available work.

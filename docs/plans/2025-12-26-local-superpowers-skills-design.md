# Local Superpowers Skills Design

## Goal

Copy superpowers plugin skills, commands, and agents to the dotfiles repo for version control and customization, with symlinks for global availability.

## Structure

```
~/dotfiles/.claude/
├── settings.json      (existing)
├── commands/
│   ├── plan-code-changes.md   (existing)
│   ├── brainstorm.md          (from superpowers)
│   ├── execute-plan.md        (from superpowers)
│   └── write-plan.md          (from superpowers)
├── skills/
│   ├── brainstorming/
│   ├── condition-based-waiting/
│   ├── defense-in-depth/
│   ├── dispatching-parallel-agents/
│   ├── executing-plans/
│   ├── finishing-a-development-branch/
│   ├── receiving-code-review/
│   ├── requesting-code-review/
│   ├── root-cause-tracing/
│   ├── sharing-skills/
│   ├── subagent-driven-development/
│   ├── systematic-debugging/
│   ├── test-driven-development/
│   ├── testing-anti-patterns/
│   ├── testing-skills-with-subagents/
│   ├── using-git-worktrees/
│   ├── using-superpowers/
│   ├── verification-before-completion/
│   ├── writing-plans/
│   └── writing-skills/
└── agents/
    └── code-reviewer.md
```

## Symlinks

```
~/.claude/skills   → ~/dotfiles/.claude/skills
~/.claude/commands → ~/dotfiles/.claude/commands
~/.claude/agents   → ~/dotfiles/.claude/agents
```

## Implementation Steps

1. Copy skills from `~/.claude/plugins/cache/superpowers-marketplace/superpowers/3.6.2/skills/` to `~/dotfiles/.claude/skills/`
2. Copy commands from `~/.claude/plugins/cache/superpowers-marketplace/superpowers/3.6.2/commands/` to `~/dotfiles/.claude/commands/`
3. Copy agents from `~/.claude/plugins/cache/superpowers-marketplace/superpowers/3.6.2/agents/` to `~/dotfiles/.claude/agents/`
4. Create symlinks from `~/.claude/` to dotfiles locations
5. (Optional) Disable superpowers plugin to avoid duplicates

## Benefits

- Version controlled customizations
- Syncs across machines via dotfiles
- Globally available in all projects
- Can modify skills to personal preferences

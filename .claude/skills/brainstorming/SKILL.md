---
name: brainstorming
description: Use when creating or developing, before writing code or implementation plans - refines rough ideas into fully-formed designs through collaborative questioning, alternative exploration, and incremental validation. Don't use during clear 'mechanical' processes
---

# Brainstorming Ideas Into Designs

## Overview

Help turn ideas into fully formed designs through natural collaborative dialogue, then transition smoothly into implementation.

Start by understanding the current project context, then ask questions one at a time to refine the idea. Once you understand what you're building, present the design in small sections, checking after each section whether it looks right so far.

## The Process

**Understanding the idea:**
- Check out the current project state first (files, docs, recent commits)
- Ask questions one at a time to refine the idea
- **Use multiple choice questions** - easier to answer, keeps momentum
- Only one question per message - if a topic needs more exploration, break it into multiple questions
- Focus on understanding: purpose, constraints, success criteria

**Exploring approaches:**
- Propose 2-3 different approaches with trade-offs
- Present options conversationally with your recommendation and reasoning
- Lead with your recommended option and explain why

**Presenting the design:**
- Once you believe you understand what you're building, present the design
- Break it into sections of 200-300 words
- Ask after each section whether it looks right so far
- Cover: architecture, components, data flow, error handling, testing
- Be ready to go back and clarify if something doesn't make sense

## After the Design

When the design is validated, ask: **"Ready to plan the implementation?"**

If yes, transition to planning:

1. **Create an epic bead** with the design decisions:
   ```bash
   bd create --title="[Feature name]" --type=epic --priority=2 \
     --design="[Summarize key design decisions from brainstorm]"
   ```

2. **Create child beads** for meaningful chunks (3-7 per feature):
   ```bash
   bd create --title="[Chunk description]" --type=task --priority=2
   bd dep add <child-id> <epic-id>  # Child depends on epic
   ```

   Each chunk should be:
   - A logical commit point
   - Something an agent could pick up and make progress on independently
   - Not too granular (not "add semicolon") or too broad (not "implement everything")

3. **Determine execution strategy** and explain it:
   - **Parallel subagents** - If beads are independent, spin up subagents
   - **Sequential** - If beads have dependencies, work through them in order
   - **Fresh orchestrator** - If context is limited, provide handoff prompt

   Say what you're doing and why. Offer ripcord: "Say 'stop' if you want to change approach."

4. **Start implementation** or **provide handoff prompt**:

   If continuing in this session:
   - Mark the first ready bead as in_progress
   - Begin implementation

   If handing off (context low, user preference, or parallel orchestration needed):
   ```
   Continue implementing beads under epic beads-xxx.
   Enter [orchestrator/implementor] mode.

   Key decisions from brainstorm:
   - [Decision 1]
   - [Decision 2]
   ```

## Key Principles

- **One question at a time** - Don't overwhelm with multiple questions
- **Multiple choice preferred** - Easier to answer than open-ended
- **YAGNI ruthlessly** - Remove unnecessary features from all designs
- **Explore alternatives** - Always propose 2-3 approaches before settling
- **Incremental validation** - Present design in sections, validate each
- **Beads, not markdown** - Track work in beads, not committed plan files
- **Smooth handoffs** - Auto-continue or provide ready-to-use prompt

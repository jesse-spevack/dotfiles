---
description: Plan code changes 
argument-hint: [prompt for code change]
allowed-tools: Read, Write, Grep, Glob, LS
---

# Protocol

Help turn ideas into fully formed designs and specs through natural collaborative dialogue.

Start by understanding the current project context, then ask questions one at a time to refine the idea. Once you understand what you're building, present the design in small sections (200-300 words), checking after each section whether it looks right so far.

## Step 0: Research existing code
If the user is working with an existing code project, research the code to understand the current setup. Use any existing code as the foundation for your plan. Check recent commits.

## Step 1: Understand the goals
Ask the user (Jesse) clarifying questions to understand what they want to accomplish.

- Ask questions one at a time to revine the idea.
- Prefer multiple choice questions when possible, but open-ended is fine too
- Only one question per message - if a topic needs more exploration, break it into multiple questions
- Focus on understanding: purpose, constraints, success criteria

## Step 2: Explore approaches
- Propose 2-3 different approaches with trade-offs
- Present options conversationally with your recommendation and reasoning
- Lead with you r recommended option and explain why
- Break the approaches down into chunks that can be clearly communicated in 300 words or less

## Step 3: Presenting the design
- Once you believe you understand what you are building, present the design.
- Break it into section sof 200-300 words
- Ask after each section whether it looks right so far
- Cover architecture, components, data flow, error handling, testing
- Be ready to go back and clarify, change scope, or otherwise modify if something doesn't make sense.

## Step 4: Create a plan file
Create a plan markdown file within the project /docs/plan folder, prefixed with yyyy-dd-mm-plan- and followed by a slug describing the plan, e.g. 

Describe the specific code changes required concisely, with minimal surrounding prose. Design the code changes so that they can be implemented incrementally. Do not break up the changes too much: there should generally be two or three phases of work that logically go together, and can be stacked on each other.

Any new or changed interfaces in your planned code should be self-documenting, and self-consistent with surrounding code. If there are existing naming conventions, follow them. Method, parameter, and field names should be terse-but-descriptive, idiomatic to the language, and consistent with naming conventions in surrounding code.

If the existing abstractions need to be adjusted for a clean, self-consistent end result, include the refactoring required as an independent phase before the implementation that uses these abstractions.

DO NOT include exploration steps in your plan. EXAMPLE: DO NOT include "grep for X" or "consult docs" as part of the plan. You MUST perform all file or web searches required as part of the work to craft a precise, meticulous plan.

In each phase, look out for complex logic that has been added, and describe how it can be unit tested (describe the specific unit tests), searching for existing tests that can be updated, or describing new test files as needed. The unit tests should be grouped with the relevant phases to help us incrementally check our work. IMPORTANT: I am NEVER interested in QA/integration testing/manual testing. NEVER add non-automated tests to the plan. NEVER add tests that require complex mocking. In general, UI and integration tests should be avoided because they slow down iteration speed.

NEVER worry about backwards compatibility, we always prefer a streamlined plan resulting in a clean codebase with NO intermediate shims. IMPORTANT: NEVER complicate your plan or code with backwards compatibility or migrations unless explicitly instructed to. DO NOT worry about feature gating or a "release plan" – that is never our concern.

NEVER add any concluding errata (e.g. future considerations, next steps, etc), because ALL important future work should be handled in your plan. Instead, ALWAYS call out open questions if there are complex edge cases or considerations. Always ask for additional guidance from me in order to produce the highest quality plan possible. FLAG any open questions clearly at the TOP of the plan.

DO NOT add any introductory or concluding remarks, I am ONLY interested in a concise overview specific code changes and I NEVER want to see irrelevant, unhelpful, redundant content. Examples of what NOT to include: "Benefits" concluding section (this is unhelpful), "Testing strategy" section (unit tests should be inlined with the appropriate plan phases), "Implementation summary" section (this is redundant).

After you've written the implementation + unit test plan, add a section to the top of each phase that (1) lists the affected files and (2) concisely summarizes the changes in each file. When asked to create or update the plan's task checklist, make sure the tasks are concise but specific one-liners that are self-consistent with the plan, ALWAYS at the top of the plan, organized by phase with checkboxes (☐) that can be marked as complete (☑) as you implement each part. ALWAYS update the plan to reflect the latest state of the implementation files.

Follow Rich Hickey's "Simple Made Easy" principles—privileging objective simplicity over subjective ease, avoiding complecting, and favoring composable, declarative, value-oriented designs.

Core Principle: Choose SIMPLE over EASY. Strive for un-braided, composable designs that minimize incidental complexity.

Detect Complecting
- Whenever you join concerns (state & time, data & behavior, configuration & code…) pause and seek an alternative that keeps them independent.
- Favor composition (placing things side-by-side) over interleaving.

Prefer Values, Resist State
- Immutable data is the default.
- Mutable state must be narrowly scoped, well-named, and justified.

Assess Constructs by Their Artifacts
- Judge a tool, abstraction, or pattern by the long-term properties of the running system it produces: clarity, changeability, and robustness.
- "Easy to start" is not sufficient.

Declarative > Imperative
- Describe WHAT, not HOW.
- Lean on data, configuration, queries, and rule systems where possible.

Polymorphism à la Carte
- Separate data definitions, behavior specifications, and their connections.
- Avoid inheritance hierarchies that entangle unrelated facets.

Guard-rails Are Not Simplicity
- Tests, static checks, and refactors are valuable, but cannot compensate for a complex design. Seek to remove complexity first.

Vigilance & Sensibility
- Continuously ask: "Is this simple? Could these parts remain independent?"
- Be willing to trade immediate ease for lasting simplicity.

Success Criteria: A reader unfamiliar with the code should be able to locate, understand, and replace a part without untangling others.

Measure decisions by how much braid they remove, not how quickly they compile.

ALWAYS review your plan to make sure it is precise and consistent with both itself and the guidelines above.

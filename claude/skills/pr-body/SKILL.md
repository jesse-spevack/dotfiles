---
name: pr-body
description: Write or rewrite a pull request title and body in Jesse's format. Use before every `gh pr create` and whenever a PR body must be fixed. Sections are Summary, Background, New with a mermaid diagram and a plain technical description, Decisions ordered by review need, and AGENTS.
---

# PR title and body

Every pull request Jesse reads uses this shape. The body must make sense to a product manager, an engineer, a designer, and a CEO, and it must leave a trail for the next agent.

## Title

`Type - product manager headline clause`

- Type is one of `Fix`, `Feature`, `Chore`, `Refactor`, `Docs`, `Test`, `Ops`.
- The clause says what the product does now, in words a customer would use. Not the file, not the method.
- Good: `Fix - free accounts keep their second free episode`. Bad: `fix: guard DebitsEpisodeCredit on on_credit_path?`.

The squash commit subject keeps the semantic prefix form (`fix:`, `feat:`) from the code conventions. The PR title is for people.

## Body

```
## Summary
One bottom line up front. What was wrong or missing, who it affected, what is true now. One to three sentences. No code names.

## Background
One sentence on the current behavior and why it is that way.

## New
One sentence on the new behavior, in product manager language.

A mermaid diagram of how the change fits into the system.

A brief technical description. Assume the reader has not seen the code. Name the one or two files that matter, in prose.

### Decisions
Bullet list of technical decisions, ordered by how much they need review, most first. Each bullet: the decision, the alternative, why this one.

## AGENTS
What a future agent needs: the test that proves the behavior, traps in the surrounding code, the signal to watch after deploy, the risk read with the named tests that catch each regression, anything the plan or review changed.
```

Close with `Closes #N` when the PR closes an issue.

## Rules

- ASD-STE100 throughout: short sentences, active voice, one idea per sentence. No em dashes.
- No attribution lines. No Co-Authored-By, no session links, no "Generated with" footers.
- The mermaid diagram shows the path the change sits on, not the whole app. Five to ten nodes. Mark the new or changed node. Use `flowchart LR` for request paths and `sequenceDiagram` for multi-service exchanges. A dotted edge marks the old behavior when that helps the reader.
- Decisions are ordered by review need. The first bullet is the one a reviewer must disagree with if they disagree at all.
- AGENTS is not a summary. It is the part a reviewer can skip and a future agent cannot.
- Numbers go in the body only when they change what the reader does. Row counts for a back-fill, yes. Test run totals, no.

## How to apply

- New PR: write the body to a file, then `gh pr create --base main --title "<Type - clause>" --body-file <file>`.
- Existing PR that does not match: `gh pr edit <n> --title "<Type - clause>" --body-file <file>`.
- A builder subagent gets this skill's template in its brief. The orchestrator rewrites any body that arrives in another shape before Jesse sees it.

## Worked example

PR #553 in jesse-spevack/tts, 2026-09-14.

Title: `Fix - free accounts keep their second free episode`

```
## Summary

Free accounts get two episodes a month, but after the first one the second failed with "Insufficient credits". Four of the eight free users who ever made one episode stopped there. This fixes it.

## Background

Creating an episode runs the credit debit for every user, and for a free user that debit creates an empty credit balance row, which the app then reads as "this person is a credit customer with no credits".

## New

A free user makes two episodes a month, as advertised, and never sees a credits message until they buy a pack.

(mermaid flowchart: submit -> permission check -> CreatesEpisode -> DebitsEpisodeCredit with the new free-tier skip beside the existing unlimited skip; a dotted edge shows the old path that created the zero-balance row)

The debit service now returns a skipped result for any user who is not on the credit path, in the same place it already skips unlimited users. Nothing else changes.

### Decisions

- The guard lives in the debit service, not in the predicate. Changing the predicate would need a purchase-history query on every call and would break fixtures. Review this first.
- The guard uses the same predicate the permission check routes by, so the two agree by construction.
- Affected users do not self-heal. A one-time delete runs after deploy. Jesse runs it.
- No migration and no change to URL episodes.

## AGENTS

- The reproduction is test/integration/free_tier_episode_flow_test.rb. Keep it.
- User#on_credit_path? is true whenever a credit balance row exists, even at zero. CreditBalance.for is find-or-create, so calling it is a write.
- Found by the metrics audit on #521. Watch the one-episode users query after deploy.
- Risk: medium, every synchronous create path runs through this service. Named regression tests: debits_episode_credit_test "delegates to DeductsCredit for credit user with balance"; checks_episode_creation_permission_test "returns failure for credit user when balance is below anticipated_cost".

Closes #549
```

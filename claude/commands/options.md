---
description: Structure a decision point into options with pros, cons, scope, confidence, and a recommendation
---

# Options analysis

You just hit a decision point. Instead of asking me an open-ended question, structure your thinking.

## Before generating options

Identify what you'd need to know to be confident. Then go find out. Read code, check docs, grep for usage, look at git history. Only surface questions you genuinely can't answer yourself.

## Output format

```
## Options

### 1. [Option name]
[One sentence description]

| | |
|:--|:--|
| Pros | [comma-separated list] |
| Cons | [comma-separated list] |
| Scope | S / M / L / XL |
| Confidence | High / Medium / Low |

### 2. [Option name]
...

## Open questions
[Bulleted list of questions only Jesse can answer that would increase confidence. Skip if none.]

## Recommendation
[Which option and why, in 1-2 sentences.]
```

## Rules

- 2-5 options. Don't pad with bad options to fill space.
- Scope is t-shirt size, not time. S = a few lines, XL = multi-file restructuring across systems.
- Confidence = how sure you are this option solves the problem well. High means you've seen it work. Low means it's speculative.
- Open questions must be specific, answerable, and things you can't resolve yourself.
- If one option clearly dominates, say so. Don't hedge.

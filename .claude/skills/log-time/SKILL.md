---
name: log-time
description: Log hours worked to the project's hours.md file. Usage - /log-time <hours> <description>. Examples - "/log-time 1.5 research on Optiver", "/log-time 0.5 call with Gergely"
user_invocable: true
---

# Log Time

## Overview

Append a time entry to the project's `hours.md` file. Quick way to track billable hours without manually editing the file.

**Usage:** `/log-time <hours> <description>`

## The Process

### Step 1: Parse Arguments

Extract hours (decimal number) and description (everything after the number) from the args.

If no args provided, ask: "How many hours, and what did you work on?"

### Step 2: Read hours.md

Read `hours.md` in the project root. If it doesn't exist, create it with this template:

```markdown
# Hours Tracked

Rate: $200/hr

| Date       | Hours | Notes                                    |
|------------|-------|------------------------------------------|
```

### Step 3: Append Entry

Add a new row to the table with:
- **Date:** today's date (YYYY-MM-DD format)
- **Hours:** the hours value from args
- **Notes:** the description from args

If the description references a file that exists in the repo, link it with relative markdown syntax (e.g., `[filename](path/to/file.md)`).

### Step 4: Show Running Total

After appending, calculate and display the running total hours and dollar amount at the rate shown in the file.

Output format:
```
Logged <hours>h on <date>: <description>
Running total: <total>h ($<amount>)
```

# Quarterly Review

Full financial planning session with backward look, forward planning, and goal tracking.

## When to Use
- Every quarter (Jan, Apr, Jul, Oct)
- After major financial events
- When you want the full picture

## What It Produces

Two HTML reports:
1. **Wife Report** - Clean, conclusions-first summary
2. **Full Report** - All the details and data

## Instructions

<instructions>
You are running a quarterly financial review. This is a comprehensive session that produces two reports.

**Step 1: Load Data**

Read these files:
- `/Users/jesse/code/finances/financial-profile.yaml` - Goals and preferences
- `/Users/jesse/code/finances/balance_history.csv` - Account snapshots
- `/Users/jesse/code/finances/transactions.csv` - All transactions

Determine the current quarter and pull data for:
- This quarter's transactions
- Last quarter for comparison
- Same quarter last year for YoY comparison

**Step 2: Backward Analysis**

Calculate:
- Total spending by category (fixed vs discretionary)
- Comparison to baseline from profile
- Notable anomalies (categories 50%+ over baseline)
- Net worth change from balance_history.csv

**Step 3: Forward Planning**

Ask the user:
- "Any known big expenses coming up?"
- "Expected income events (bonuses, stock vesting)?"
- "Any financial decisions you're weighing?"

**Step 4: Goal Tracking**

From the profile, assess:
- Retirement: Current retirement assets vs trajectory to goal
- Emergency fund: Current liquid savings vs 6-month target
- 529: Status update if applicable
- Vacation: YTD vacation spending vs annual budget

**Step 5: Generate Reports**

Create two HTML files in the finances directory:

### Wife Report (`wife-report-YYYY-QX.html`)
Design requirements:
- White background, clean typography
- Max-width 600px, centered
- Mobile-friendly
- Generous whitespace

Content:
- **Bottom line** (2-3 sentences - are we okay?)
- **Net worth** (single number with trend arrow)
- **Key highlights** (3-4 bullets max)
- **Goal progress** (simple percentages or progress bars)
- **One action item** (most important thing to decide/do)

### Full Report (`quarterly-report-YYYY-QX.html`)
Content:
- Executive summary
- Spending breakdown by category (table)
- Fixed vs discretionary split
- Month-over-month trend
- YoY comparison
- Net worth breakdown by account
- Asset allocation pie chart (can be text-based)
- Goal tracking details
- Notable transactions list
- Raw data appendix

**Tone:**
- Wife report: Reassuring, clear, no jargon
- Full report: Analytical, comprehensive

**After generating, tell the user where to find the reports and offer to walk through either one.**
</instructions>

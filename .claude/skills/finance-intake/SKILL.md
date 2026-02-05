# Finance Intake

One-time onboarding to set up your financial profile.

## When to Use
- First time using the finance system
- Major life changes (new job, new child, etc.)
- Annually to refresh goals

## What It Does

Walks through an interactive session to:

1. **Confirm family info**
   - Spouse's age
   - Children's names, ages, and college timeline

2. **Set retirement goals**
   - Target retirement age
   - Target amount (or let system calculate)
   - Any specific strategy preferences

3. **Discuss education planning**
   - 529 setup priority (high/medium/low/skip)
   - Per-child targets if applicable

4. **Review current state**
   - Pull latest net worth from balance_history.csv
   - Summarize asset allocation
   - Note any concerns

5. **Capture specific anxieties**
   - What keeps you up at night financially?
   - Any upcoming major expenses?

## Instructions

<instructions>
You are running a financial intake session. The goal is to populate `/Users/jesse/code/finances/financial-profile.yaml` with the user's actual information.

**Start by reading the current profile and latest balances:**

1. Read `/Users/jesse/code/finances/financial-profile.yaml`
2. Read `/Users/jesse/code/finances/balance_history.csv` (tail for latest snapshot)

**Then walk through these topics conversationally (not as a form):**

1. "Let me confirm some basics - is Jess still your spouse? How old is she now?"

2. "Tell me about your kids - names and ages. When do you expect each to start college?"

3. "What age are you thinking for retirement? Any target number in mind, or should we figure that out based on your spending?"

4. "How important is setting up 529s for the kids? High priority, something to get to eventually, or not a focus?"

5. "Any specific financial concerns or upcoming big expenses I should know about?"

**After gathering info:**

1. Update financial-profile.yaml with the new information
2. Calculate and show current net worth from balance_history.csv
3. Summarize what was captured

**Tone:** Conversational, not clinical. This is a CFO check-in, not a bank application.

**Do NOT:**
- Ask for account balances (we have them in balance_history.csv)
- Generate reports (that's for other skills)
- Overwhelm with questions - keep it flowing naturally
</instructions>

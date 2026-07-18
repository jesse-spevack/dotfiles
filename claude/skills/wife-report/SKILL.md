# Wife Report

Generate a clean, simple financial summary designed for quick understanding.

## When to Use
- Quick status check without full quarterly review
- Sharing financial snapshot with spouse
- When you want conclusions, not data

## Design Philosophy

This report is for someone who:
- Wants to know "are we okay?" in 30 seconds
- Doesn't want to see spreadsheets
- Trusts the details are handled
- Appreciates clean, calm presentation

## Instructions

<instructions>
You are generating a clean financial summary report.

**Step 1: Load Data**

Read:
- `/Users/jesse/code/finances/financial-profile.yaml`
- `/Users/jesse/code/finances/balance_history.csv` (latest + previous month for trend)
- `/Users/jesse/code/finances/transactions.csv` (last 3 months)

**Step 2: Calculate Key Metrics**

- Current net worth (assets - liabilities from balance_history)
- Net worth trend (vs last month, vs 3 months ago)
- Recent spending total vs baseline
- Any category significantly over budget

**Step 3: Generate Report**

Create `wife-report-YYYY-MM.html` with this structure:

```html
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Financial Summary - Month Year</title>
  <style>
    * { box-sizing: border-box; margin: 0; padding: 0; }
    body {
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
      background: #fff;
      color: #333;
      line-height: 1.6;
      padding: 40px 20px;
    }
    .container {
      max-width: 500px;
      margin: 0 auto;
    }
    h1 {
      font-size: 1.5rem;
      font-weight: 500;
      margin-bottom: 2rem;
      color: #111;
    }
    .bottom-line {
      font-size: 1.1rem;
      margin-bottom: 2.5rem;
      padding: 1.5rem;
      background: #f8f9fa;
      border-radius: 8px;
    }
    .metric {
      margin-bottom: 2rem;
    }
    .metric-label {
      font-size: 0.85rem;
      color: #666;
      text-transform: uppercase;
      letter-spacing: 0.5px;
      margin-bottom: 0.25rem;
    }
    .metric-value {
      font-size: 2rem;
      font-weight: 600;
    }
    .metric-trend {
      font-size: 0.9rem;
      color: #666;
    }
    .trend-up { color: #22c55e; }
    .trend-down { color: #ef4444; }
    .highlights {
      margin-bottom: 2rem;
    }
    .highlights h2 {
      font-size: 1rem;
      font-weight: 500;
      margin-bottom: 1rem;
    }
    .highlights ul {
      list-style: none;
    }
    .highlights li {
      padding: 0.5rem 0;
      border-bottom: 1px solid #eee;
    }
    .highlights li:last-child {
      border-bottom: none;
    }
    .action {
      background: #f0f9ff;
      padding: 1.5rem;
      border-radius: 8px;
      border-left: 3px solid #0ea5e9;
    }
    .action-label {
      font-size: 0.8rem;
      color: #0369a1;
      text-transform: uppercase;
      letter-spacing: 0.5px;
      margin-bottom: 0.5rem;
    }
  </style>
</head>
<body>
  <div class="container">
    <h1>Financial Summary</h1>

    <div class="bottom-line">
      <!-- 2-3 sentence summary: Are we on track? Any concerns? -->
    </div>

    <div class="metric">
      <div class="metric-label">Net Worth</div>
      <div class="metric-value">$XXX,XXX</div>
      <div class="metric-trend trend-up">↑ $X,XXX from last month</div>
    </div>

    <div class="highlights">
      <h2>This Month</h2>
      <ul>
        <li><!-- Highlight 1 --></li>
        <li><!-- Highlight 2 --></li>
        <li><!-- Highlight 3 --></li>
      </ul>
    </div>

    <div class="action">
      <div class="action-label">Action Item</div>
      <p><!-- One thing to discuss or decide --></p>
    </div>
  </div>
</body>
</html>
```

**Content Guidelines:**

- **Bottom line**: Start with the answer. "We're in good shape this month." or "Spending was high but expected due to X."
- **Net worth**: Round to nearest thousand. Show trend.
- **Highlights**: Pick 3-4 interesting things. Can be positive or noteworthy.
- **Action item**: One specific thing. "Decide on summer camp budget" not "Review finances."

**What NOT to include:**
- Category breakdowns
- Tables of numbers
- Multiple charts
- Anything requiring scrolling on mobile
- Financial jargon

**After generating, provide the file path and offer to open it.**
</instructions>

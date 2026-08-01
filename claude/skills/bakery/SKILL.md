---
name: bakery
description: Generate monthly bakery blog post from js-notes items and publish as Ghost draft
---

# Bakery

Monthly workflow that pulls captured content from js-notes, generates commentary options,
and updates a Ghost draft post via the ghst CLI.

## When to Use

- End of month / start of next month when assembling the bakery post
- Invoke with `/bakery [month-year]` (e.g., `/bakery march-2026`, defaults to current month)

## Process

### Step 1: Resolve Month & Find Draft

- Parse the month argument (e.g., "march-2026") or default to current month
- Find the Ghost draft post: `ghst post list --status draft` and match "{Month} {Year} Bakery"
- If no draft exists, create one: `ghst post create --title "{Month} {Year} Bakery" --status draft --tags Bakery`

### Step 2: Fetch js-notes Items

Use the **js-notes MCP connector tools** (`mcp__claude_ai_js-notes__list_recent`, `mcp__claude_ai_js-notes__get_item`).
Do not hand-roll curl against `/mcp` — see "js-notes API Access" below for why.

- `list_recent` to enumerate items, then filter to the target month
- **`list_recent` caps at 50 items regardless of the `limit` you pass.** A busy month exceeds that.
  To reach further back, call it once per `source_type` (`article`, `video`, `podcast`, `social`);
  each filtered list returns its own 50, which together cover a full month. Cross-check the id
  sequence for gaps, then confirm any missing id with `get_item` (a "not found" means a deleted
  capture, not a miss).
- Check the previous month's published bakery post for its oldest item, so the new post starts
  where the last one stopped rather than at a date boundary.
- `get_item` returns the item's **full text**, which is often 50-200KB and will blow up context.
  When the tool result gets persisted to a file, read only the **first ~16-22 lines** — title,
  author, source, URL, tags, captured, summary, and key points all live in that header. Never read
  the whole file just to write a one-sentence blurb.
- Deduplicate (same URL or same title), skip items with no URL or broken titles (e.g., "Just a moment...")
- Metadata is AI-extracted and sometimes wrong. Sanity-check the author against the domain
  (a `world.hey.com/dhh` post is DHH, whatever the author field says) and flag mismatches.

**Clean the URLs before they reach the post:**
- Strip Substack/newsletter tracking params (`?isFreemail=`, `post_id=`, `publication_id=`, `r=`,
  `triedRedirect=`, `token=`) — keep only the bare `/p/slug`
- Resolve `share.google/...` redirects to the real canonical URL and verify the title matches
- Prefer the canonical `youtube.com/watch?v=ID` over `youtube.com/watch?is=...&v=ID`

### Step 3: Generate Commentary (Interactive)

Present items one at a time (newest first), showing:
- Title, URL, source type, tags
- Summary (2-3 sentences)

For each item, offer **4 options**:
- **A)** Blurb option 1 — pithy/opinionated, 1 sentence
- **B)** Blurb option 2 — quote-forward, pulls from summary/key_points
- **C)** Blurb option 3 — contextual, connects to Jesse's work or interests
- **D)** Write your own — Jesse types custom commentary
- **S)** Skip this item entirely

Collect the chosen blurb for each item.

### Step 4: Build Lexical JSON & Update Draft

- Build Ghost Lexical JSON (see format reference below):
  - Intro paragraph linking to [js-notes](https://notes.verynormal.dev)
  - Horizontal rule
  - For each item: paragraph (commentary) + bookmark node (or YouTube embed for video URLs)
  - Trailing empty paragraph
- Write to `/tmp/{month}-bakery-lexical.json`
- Update the draft:
  ```
  ghst post update {id} --lexical-file /tmp/{month}-bakery-lexical.json --tags Bakery --excerpt "Content that caught my attention all in one go!"
  ```
- Report: item count, items skipped, draft slug
- Remind Jesse to open in Ghost editor to verify bookmark previews render correctly

## Output

- Updated Ghost draft post with all selected items in bakery format
- Summary report: item count, items skipped, draft slug

## Ghost Lexical Format Reference

The bakery post uses these Ghost Lexical node types:

**Paragraph** (commentary):
```json
{
  "children": [{"detail": 0, "format": 0, "mode": "normal", "style": "",
    "text": "Commentary here", "type": "extended-text", "version": 1}],
  "direction": "ltr", "format": "", "indent": 0, "type": "paragraph", "version": 1
}
```

**Bookmark** (link preview — Ghost auto-fetches metadata in editor):
```json
{
  "type": "bookmark", "version": 1, "url": "https://...",
  "metadata": {"icon": "", "title": "", "description": "", "author": "", "publisher": "", "thumbnail": ""},
  "caption": ""
}
```

**YouTube Embed**:
```json
{
  "type": "embed", "version": 1, "url": "https://www.youtube.com/watch?v=...",
  "embedType": "video",
  "html": "<iframe width=\"200\" height=\"113\" src=\"https://www.youtube.com/embed/{VIDEO_ID}?feature=oembed\" frameborder=\"0\" allow=\"accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share\" referrerpolicy=\"strict-origin-when-cross-origin\" allowfullscreen title=\"\"></iframe>",
  "metadata": {"provider_name": "YouTube", "provider_url": "https://www.youtube.com/"}
}
```

**Horizontal rule**:
```json
{"type": "horizontalrule", "version": 1}
```

**Intro paragraph with link**:
```json
{
  "children": [
    {"children": [{"text": "js-notes", "type": "extended-text", "detail": 0, "format": 0, "mode": "normal", "style": "", "version": 1}],
     "type": "link", "version": 1, "direction": "ltr", "format": "", "indent": 0, "rel": null, "target": null, "title": null, "url": "https://notes.verynormal.dev"},
    {"text": " is my personal knowledge management system. It captures articles, podcasts, and videos, extracts their full text, and enriches them with AI-generated summaries and semantic search. This is everything that caught my attention in {Month} {Year}.",
     "type": "extended-text", "detail": 0, "format": 0, "mode": "normal", "style": "", "version": 1}
  ],
  "type": "paragraph", "version": 1, "direction": "ltr", "format": "", "indent": 0
}
```

**Wrapping structure** — all nodes go inside:
```json
{"root": {"children": [...nodes...], "direction": "ltr", "format": "", "indent": 0, "type": "root", "version": 1}}
```

## js-notes API Access

**Use the MCP connector tools. The bearer-token curl recipe no longer works.**

`McpController` used to `include TokenAuthentication`, which compared the bearer token against
`API_TOKEN`. Commit `2fa15ca` (#70, "Add OAuth 2.1 for MCP endpoint (claude.ai integration)",
2026-04-05) replaced that with `before_action :doorkeeper_authorize!`. Since then `/mcp` accepts
only Doorkeeper OAuth access tokens and never consults `API_TOKEN`, so hand-rolled curl gets a
flat `401 {"error":"unauthorized"}`.

The `API_TOKEN` in 1Password (`keys/js-notes`) is still valid — it just authenticates
`POST /api/items`, `POST /api/items/share`, and the `/login` form. It has no authority on `/mcp`.
Fetching it for bakery work is wasted effort.

- **Tools**: `mcp__claude_ai_js-notes__list_recent`, `mcp__claude_ai_js-notes__get_item`
  (also available: `search_knowledge`, `add_note`, `save_url`)
- **`list_recent`**: `{limit, source_type?, tag?}` — hard cap of 50 results; fan out across
  `source_type` values to cover a full month
- **`get_item`**: `{id}` — returns full text; read only the header lines (see Step 2)
- There is **no update tool**. Correcting a field like `author` means a runner on the box:
  `kamal app exec --reuse 'bin/rails runner "..."'` from `~/code/js-notes` (needs the
  `google_compute_engine` SSH key loaded via `ssh-add`). The web `items#update` action only
  permits `:notes` and `:url`.

## Example

```
Jesse: /bakery march-2026

Claude: Found draft "March 2026 Bakery" (69aa334d...).
        Fetching March items from js-notes... 46 items found.

        Let's build commentary. For each item, pick A/B/C, type your own (D), or skip (S).

        ---
        **[1/46] Harness design for long-running application development**
        anthropic.com/engineering | article | Tags: ai agents, prompt engineering
        > Multi-agent AI system inspired by GANs to improve Claude's frontend design quality.

        A) "From Anthropic engineering -- a GAN-inspired approach to frontend design quality in multi-agent systems."
        B) "Addresses the key challenge of getting AI to produce high-quality frontend code autonomously."
        C) "From one of our engineers on multi-agent systems for full-stack apps. The adversarial approach to design quality is clever."
        D) Write your own
        S) Skip

Jesse: C

        **[2/46] Bring your AI agents to Basecamp**
        ...

[after all items]

Claude: Built 42 items (4 skipped). Updating Ghost draft...
        Done -- draft updated: march-2026-bakery
        Open in Ghost editor to verify bookmark previews render correctly.
```

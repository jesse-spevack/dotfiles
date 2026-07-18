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

- Get the API token from 1Password via Kamal:
  ```
  kamal secrets fetch --adapter 1password --account VLVMNHTN7NCBZGTYBDOUCQ5EMU --from keys/js-notes API_TOKEN
  ```
  Then extract the token value:
  ```
  echo '{result}' | python3 -c "import sys,json; print(list(json.load(sys.stdin).values())[0])"
  ```
- Call the js-notes MCP endpoint (`POST https://notes.verynormal.dev/mcp`) with `list_recent` (limit 50)
- Filter to items captured within the target month
- For each item, call `get_item` in parallel (background curl) to get title, URL, summary, key_points, notes, and tags
- Deduplicate (same URL or same title), skip items with no URL or broken titles (e.g., "Just a moment...")

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

- **Endpoint**: `POST https://notes.verynormal.dev/mcp` (JSON-RPC 2.0)
- **Auth**: `Authorization: Bearer {token}`
- **Token retrieval**:
  ```bash
  kamal secrets fetch --adapter 1password --account VLVMNHTN7NCBZGTYBDOUCQ5EMU --from keys/js-notes API_TOKEN
  ```
- **Initialize session** (required before tool calls):
  ```json
  {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"bakery","version":"1.0"}}}
  ```
- **List items**:
  ```json
  {"jsonrpc":"2.0","id":2,"method":"tools/call","params":{"name":"list_recent","arguments":{"limit":50}}}
  ```
- **Get item detail**:
  ```json
  {"jsonrpc":"2.0","id":3,"method":"tools/call","params":{"name":"get_item","arguments":{"id":ID}}}
  ```

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

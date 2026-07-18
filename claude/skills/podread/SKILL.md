---
name: podread
description: Convert articles, URLs, or text to podcast episodes using the podread CLI
---

# podread CLI

Use the `podread` CLI to convert articles, URLs, or text into podcast episodes via podread.app. Episodes are processed server-side and delivered through an RSS feed you can subscribe to in any podcast app.

## When to Use

- User wants to convert an article or URL to audio/podcast
- User wants to turn text content into a listenable episode
- User mentions podread directly
- User asks about their podcast feed or episode status

## When NOT to Use

- User asks to pay PodRead, or names the Link CLI, MPP, Stripe SPT, x402, or Tempo — those are the public paid surfaces. Read https://podread.app/docs/mpp/link-cli and execute via `link-cli`, not `podread`.
- User wants narration delivered to someone other than Jesse (the `podread` CLI is bound to his account).

## Authentication

Before any other command, the user must be logged in.

```bash
# Check if already authenticated
podread auth status

# Login via device auth flow (opens browser)
podread auth login

# Clear stored credentials
podread auth logout
```

The login flow displays a code and URL. The user authorizes in their browser, and the CLI picks up the token automatically.

## Creating Episodes

### From a URL

```bash
podread episode create --url https://example.com/article
```

### From inline text

```bash
podread episode create --text "Your long-form text here..." --title "Episode Title"
```

### From piped input (stdin)

```bash
echo "Long text content" | podread episode create --stdin --title "Episode Title"
cat article.txt | podread episode create --stdin --title "From File"
```

### Options

| Flag | Purpose |
|------|---------|
| `--url <url>` | Source URL to convert |
| `--text "..."` | Inline text to convert |
| `--stdin` | Read text from stdin |
| `--title "..."` | Episode title |
| `--voice <name>` | Voice to use (see `podread voices`) |
| `--no-wait` | Return immediately without waiting for processing |
| `--timeout 300` | Custom timeout in seconds (default: 600) |
| `--json` | Output as JSON |

By default, `episode create` waits for processing to complete. Use `--no-wait` to get the episode ID back immediately and check status later.

## Managing Episodes

```bash
# List recent episodes (ep is an alias for episode)
podread ep list
podread ep list --limit 20
podread ep list --json

# Check processing status of a specific episode
podread episode status <id>

# Delete an episode
podread episode delete <id>
```

## Voices and Feed

```bash
# List available voices
podread voices

# Show your RSS feed URL (subscribe in any podcast app)
podread feed
```

## Common Workflows

### First-time setup

```bash
podread auth login
# Follow the browser auth flow, then:
podread feed
# Copy the RSS feed URL into your podcast app
```

### Convert an article and wait for it

```bash
podread episode create --url https://example.com/long-article
# CLI waits and reports when the episode is ready
```

### Fire-and-forget with status check

```bash
podread episode create --url https://example.com/article --no-wait --json
# Returns episode ID immediately

# Check on it later
podread episode status <id>
```

### Pipe text content into an episode

```bash
cat notes.md | podread episode create --stdin --title "Meeting Notes"
```

### Check recent episodes as JSON

```bash
podread ep list --json | jq '.[0]'
```

## Notes

- The `--json` flag is available on most commands and is useful for scripting or piping to `jq`.
- `ep` is a shorthand alias for `episode` in all subcommands.
- Episode processing typically takes 1-5 minutes depending on length.
- The RSS feed URL is stable -- subscribe once and new episodes appear automatically.

# Code Conventions

General code-writing conventions that apply across projects.

## Comments

Default to zero comments. Code with well-named identifiers documents itself. The bar for adding one is much higher than feels natural.

- **One short line max** when you must - explain the non-obvious *why* (hidden constraint, workaround, subtle invariant).
- **Never multi-line blocks** above methods or expressions. No paragraph-style explanations. If a method needs a paragraph, the method is wrong - extract or rename until it doesn't.
- **Never the WHAT** - well-named code already shows that.
- **Never the HISTORY** - "added for X", "used by Y", "see PR #123" rot fast; that belongs in the commit message or PR body.
- **Sniff test before committing:** if comment-line-count >= code-line-count, delete or shrink. Re-read every new comment and ask "would removing this confuse a future reader?" - if no, delete.

This applies to the code itself. When justifying a change in chat, PR description, or notes, be as detailed as needed - those are read once. Comments are read forever.

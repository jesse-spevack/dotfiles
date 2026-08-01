#!/usr/bin/env bash
# bootstrap.sh — set up a fresh macOS machine from these dotfiles.
# Idempotent: safe to re-run.

set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"
PACKAGES=(zsh git tmux nvim ghostty starship ssh)

log() { printf "\n\033[1;34m==>\033[0m %s\n" "$*"; }

# 1. Homebrew
if ! command -v brew >/dev/null 2>&1; then
  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  else
    log "Installing Homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
fi

# 2. brew bundle
log "Running brew bundle"
brew bundle --file="$DOTFILES_DIR/Brewfile"

# 3. Oh My Zsh
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  log "Installing Oh My Zsh"
  RUNZSH=no KEEP_ZSHRC=yes sh -c \
    "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# 4. Tmux Plugin Manager (tpm)
if [[ ! -d "$HOME/.config/tmux/plugins/tpm" ]]; then
  log "Cloning tpm"
  mkdir -p "$HOME/.config/tmux/plugins"
  git clone https://github.com/tmux-plugins/tpm "$HOME/.config/tmux/plugins/tpm"
fi

# 5. asdf plugins (ruby + nodejs)
if command -v asdf >/dev/null 2>&1; then
  log "Adding asdf plugins"
  asdf plugin add ruby   https://github.com/asdf-vm/asdf-ruby.git   || true
  asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git || true
fi

# 5b. fizzy CLI (not actually on Homebrew despite README claims)
if [[ ! -x "$HOME/.local/bin/fizzy" ]]; then
  log "Installing fizzy CLI"
  curl -fsSL https://raw.githubusercontent.com/basecamp/fizzy-cli/master/scripts/install.sh | bash || true
fi

# 6. Back up any pre-existing dotfiles that would conflict with stow
log "Backing up existing dotfiles that would block stow"
TS="$(date +%Y%m%d-%H%M%S)"
for f in .zshrc .gitconfig; do
  target="$HOME/$f"
  if [[ -e "$target" && ! -L "$target" ]]; then
    mv "$target" "$target.backup.$TS"
    log "Backed up $target -> $target.backup.$TS"
  fi
done

# 6b. Ensure ~/.ssh is a real directory (not a wholesale symlink into dotfiles).
# Historically `stow ssh` created ~/.ssh as a directory symlink into
# ~/dotfiles/ssh/.ssh/, which meant any private key written to ~/.ssh/
# physically landed inside a public git repo. Now only `config` is stowed;
# keys must live in a real ~/.ssh/ directory. Idempotent.
if [[ -L "$HOME/.ssh" ]]; then
  log "Migrating ~/.ssh from directory symlink to real directory"
  ssh_target="$(readlink -f "$HOME/.ssh")"
  backup="/tmp/ssh-backup-$TS"
  cp -RL "$HOME/.ssh/" "$backup/"
  chmod -R go-rwx "$backup"
  log "Backup at $backup"

  park="$HOME/.ssh-migration-temp-$TS"
  mkdir -p "$park"
  chmod 700 "$park"
  (
    shopt -s dotglob nullglob
    for entry in "$ssh_target"/*; do
      [[ "$(basename "$entry")" == "config" ]] && continue
      mv "$entry" "$park/"
    done
  )

  rm "$HOME/.ssh"
  mkdir -p "$HOME/.ssh"
  chmod 700 "$HOME/.ssh"

  (
    shopt -s dotglob nullglob
    for entry in "$park"/*; do
      mv "$entry" "$HOME/.ssh/"
    done
  )
  rmdir "$park"
fi

if [[ ! -d "$HOME/.ssh" ]]; then
  mkdir -p "$HOME/.ssh"
  chmod 700 "$HOME/.ssh"
fi

# 7. Stow
log "Stowing dotfiles"
cd "$DOTFILES_DIR"
stow --restow --target="$HOME" "${PACKAGES[@]}"

# 8. Claude Code global config (~/.claude)
# dotfiles owns a few leaves inside ~/.claude; everything else there is live
# local state (sessions, history, plugins, caches) and must stay a real dir.
# We symlink each leaf individually rather than stowing ~/.claude wholesale, so
# stow never adopts or clobbers that state. settings.local.json is per-machine
# and intentionally NOT linked.
log "Linking Claude Code config into ~/.claude"
mkdir -p "$HOME/.claude"
CLAUDE_SRC="$DOTFILES_DIR/claude"
for leaf in skills commands CLAUDE.md settings.json rails-conventions.md code-conventions.md; do
  target="$HOME/.claude/$leaf"
  if [[ -e "$target" && ! -L "$target" ]]; then
    mv "$target" "$target.backup.$TS"
    log "Backed up $target -> $target.backup.$TS"
  fi
  ln -sfn "$CLAUDE_SRC/$leaf" "$target"
done

# 8b. Herdr config (~/.config/herdr)
# Same shape as ~/.ssh and ~/.claude: herdr keeps live runtime state next to
# its config - herdr.sock, herdr-client.sock, herdr.log, herdr-server.log,
# herdr-client.log, .plugins.lock. `stow herdr` folds the whole directory into
# a symlink when ~/.config/herdr does not exist yet, which puts every one of
# those files inside this git repo. So herdr is deliberately NOT in PACKAGES;
# only config.toml is linked. Idempotent.
log "Linking herdr config into ~/.config/herdr"
if [[ -L "$HOME/.config/herdr" ]]; then
  log "Migrating ~/.config/herdr from directory symlink to real directory"
  rm "$HOME/.config/herdr"
fi
mkdir -p "$HOME/.config/herdr"
herdr_target="$HOME/.config/herdr/config.toml"
if [[ -e "$herdr_target" && ! -L "$herdr_target" ]]; then
  mv "$herdr_target" "$herdr_target.backup.$TS"
  log "Backed up $herdr_target -> $herdr_target.backup.$TS"
fi
ln -sfn "$DOTFILES_DIR/herdr/.config/herdr/config.toml" "$herdr_target"

# 9. Herdr agent-state hook for Claude Code
# The hook script is generated per-machine and is not tracked here, so it has
# to come from `herdr integration install claude`. That installer also writes
# the SessionStart block into settings.json, but it round-trips the whole file
# through its own JSON model and drops keys it does not recognise - it deleted
# "fastMode" when first run. The hooks block is already tracked in
# claude/settings.json, so snapshot that file, let the installer lay down the
# script, then put the tracked version back.
if command -v herdr >/dev/null 2>&1; then
  if ! herdr integration status 2>/dev/null | grep -q '^claude: current'; then
    log "Installing herdr agent-state hook for Claude Code"
    settings_snapshot="$(mktemp)"
    cp "$CLAUDE_SRC/settings.json" "$settings_snapshot"
    herdr integration install claude
    cp "$settings_snapshot" "$CLAUDE_SRC/settings.json"
    rm -f "$settings_snapshot"
  fi
fi

cat <<'EOF'

==> Bootstrap complete.

Next steps (manual):
  1. Open a new shell so the new ~/.zshrc loads.
  2. Run `nvim` once - LazyVim will install plugins on first launch.
  3. Start tmux, then press <prefix> + I to install tpm plugins.
  4. `gh auth login` if you haven't already.
  5. `ssh-keygen -t ed25519 -C "<email>"` and upload to GitHub.
  6. Install the custom CLIs separately (fizzy, podread, ghst).
  7. `asdf install ruby <version>` / `asdf install nodejs <version>` as needed.

EOF

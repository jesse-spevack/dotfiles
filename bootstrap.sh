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
if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
  log "Cloning tpm"
  git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
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

# 7. Stow
log "Stowing dotfiles"
cd "$DOTFILES_DIR"
stow --restow --target="$HOME" "${PACKAGES[@]}"

cat <<'EOF'

==> Bootstrap complete.

Next steps (manual):
  1. Open a new shell so the new ~/.zshrc loads.
  2. Run `nvim` once — LazyVim will install plugins on first launch.
  3. Start tmux, then press <prefix> + I to install tpm plugins.
  4. `gh auth login` if you haven't already.
  5. `ssh-keygen -t ed25519 -C "<email>"` and upload to GitHub.
  6. Install the custom CLIs separately (fizzy, podread, ghst).
  7. `asdf install ruby <version>` / `asdf install nodejs <version>` as needed.

EOF

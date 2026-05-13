# Homebrew Bundle for Jesse's dotfiles
# Run via: brew bundle (or use ./bootstrap.sh which does this and more)

tap "jesse-spevack/tap"

# ---- Repo / shell plumbing ----
brew "git"
brew "gh"
brew "stow"

# ---- Core dotfiles dependencies ----
brew "tmux"
brew "neovim"
brew "starship"
brew "zsh-syntax-highlighting"
brew "yazi"
brew "asdf"

# ---- LazyVim external dependencies ----
brew "ripgrep"
brew "fd"
brew "lazygit"
brew "tree-sitter"

# ---- Ruby build deps (used when installing Ruby via asdf) ----
brew "openssl@3"
brew "libyaml"
brew "gmp"
brew "readline"
brew "autoconf"
brew "coreutils"

# ---- Workflow / package managers ----
brew "pnpm"
# Note: node is intentionally omitted — install via asdf to match the Ruby pattern.

# ---- Cloud / secrets ----
cask "google-cloud-sdk"
cask "1password-cli"

# ---- Terminal + font ----
cask "ghostty"
cask "font-jetbrains-mono-nerd-font"

# ---- Custom CLIs (from jesse-spevack/tap) ----
brew "jesse-spevack/tap/podread"

# Not yet on Homebrew — install separately:
#   - fizzy (kanban board CLI)
#   - ghst  (Ghost blog CLI)

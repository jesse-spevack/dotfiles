# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# asdf configuration
export ASDF_DATA_DIR="$HOME/.asdf"
export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"
fpath=(${ASDF_DATA_DIR:-$HOME/.asdf}/completions $fpath)
autoload -Uz compinit && compinit

# export PATH="$HOME/.asdf/bin:$PATH"
# export PATH="$ASDF_DATA_DIR/shims:$PATH"
# export PATH="$HOME/bin:$PATH"


# initialise completions with ZSH's compinit
autoload -Uz compinit && compinit

# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME=""

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

# Source ZSH after plugins load
source $ZSH/oh-my-zsh.sh

# Source zsh syntax highlighting
source $HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# If you're not using ZSH from Homebrew (brew install zsh and $(brew --prefix)/bin/zsh), you must also add the site-functions to your fpath in $HOME/.zshrc:
fpath+=("$(brew --prefix)/share/zsh/site-functions")

# Starship prompt
# https://starship.rs
eval "$(starship init zsh)"

# Tmux
# https://github.com/tmux/tmux/blob/master/FAQ
# https://github.com/tmux/tmux/wiki
# https://github.com/tmux/tmux/wiki/FAQ
# https://github.com/tmux/tmux/wiki/FAQ
export XDG_CONFIG_HOME="$HOME/.config"

alias source!="source ~/.zshrc"
alias zshconfig="code ~/.zshrc"

# Utility Aliases
alias ls="ls -laGFh"

# https://yazi-rs.github.io/docs/quick-start/
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/jesse/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/jesse/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/jesse/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/jesse/google-cloud-sdk/completion.zsh.inc'; fi

# pnpm
export PNPM_HOME="/Users/jesse/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# Ensure Node.js binaries are in PATH
export PATH="$HOME/.npm-global/bin:$PATH"

. "$HOME/.local/bin/env"

alias claude="/Users/jesse/.claude/local/claude"
alias lfg="claude --dangerously-skip-permissions"

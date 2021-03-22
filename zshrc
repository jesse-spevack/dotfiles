# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# ZSH Thenes and plugins
ZSH_THEME=""
plugins=(
  git
  zsh-osx-keychain
  vscode
)

# Source ZSH after plugins load
source $ZSH/oh-my-zsh.sh

# ZSH aliases
alias zshconfig="code ~/.zshrc"
alias source!="source ~/.zshrc"

# ASDF - for language versions
# https://github.com/asdf-vm/asdf
. $HOME/.asdf/asdf.sh
export GUILE_TLS_CERTIFICATE_DIRECTORY=/usr/local/etc/gnutls/

# Pure prompt - my beautiful theme
# https://github.com/sindresorhus/pure#getting-started
# https://github.com/sindresorhus/iterm2-snazzy/blob/main/readme.md
autoload -U promptinit; promptinit
zstyle :prompt:pure:git:stash show yes
prompt pure

# Utility Aliases
alias ls="ls -laGFh"

# Git
alias gcm="git commit --amend --no-edit"

# Bundler
alias be="bundle exec"
alias bers="bundle exec rspec --format documentation"

# Jekyll
alias jeks="jekyll serve -w --force_polling"

# Postgres
alias pgst="pg_ctl start"
alias pgsp="pg_ctl stop"

# Rails
alias rsp="be rails server -p"
alias web_server="./bin/webpack-dev-server"

# Ibotta Aliases
alias reset_tools="ssh-keygen -R tools.ibotta.com"

# Drake
alias drake="saml2aws exec --exec-profile=monolith -- ~/Ibotta/bin/drake"
alias dt="drake spring rspec --format documentation"
alias dta="drake spring:admin rspec --format documentation"
alias dc="drake console"
alias dca="drake console:admin"

# SAML
alias saml-login="saml2aws login --role=arn:aws:iam::$(keychain-environment-variable AWS_ACCOUNT_ID):role/PlatformEngineerLogin --skip-prompt --session-duration=43200 --force"
alias saml-monolith="saml2aws exec --exec-profile monolith --"
alias saml-k8s="saml2aws exec --exec-profile prod-k8s --"

# On call items
alias oncall-check="saml-monolith ibotta_cli application revisions api-server 'environment:production'"
alias oncall-deploy="saml-monolith ibotta_cli application deploy_api_server_production"
alias oncall-verify="saml-monolith ibotta_cli application verify_revisions api-server 'role:api_server*'"
alias oncall-fix="saml-monolith ibotta_cli application deploy_api_server_production --fix"
alias oncall-migrate="saml-monolith ./bin/drake db:migration:prod"
alias oncall-rollback="saml-monolith ibotta_cli application rollback_api_server_production"

# ENV Variables
# https://github.com/onyxraven/zsh-osx-keychain
export GITHUB_API_TOKEN="$(keychain-environment-variable GITHUB_API_TOKEN)"
export NPM_BASE="https://ibdolphin.jfrog.io/ibdolphin/api/npm"
export NPM_REPO_LOGIN="readonly:$(keychain-environment-variable NPM_REPO_LOGIN)"
export GEM_REPO_LOGIN="readonly:$(keychain-environment-variable GEM_REPO_LOGIN)"
export MVN_REPO_LOGIN="$GEM_REPO_LOGIN"

# SAML AWS Quality of Life
# https://ibotta.atlassian.net/wiki/spaces/TT/pages/451510679/Getting+started+with+saml2aws  
export AWS_SESSION_TTL=12h
export AWS_FEDERATION_TOKEN_TTL=12h
export AWS_ASSUME_ROLE_TTL=1h
export AWS_REGION=us-east-1

# ZSH
source /Users/jesse.spevack/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

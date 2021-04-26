# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# ZSH Thenes and plugins
ZSH_THEME=""
plugins=(
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

# Heavily borrowed from https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/git/git.plugin.zsh
# But only including things I use.
# Check if main exists and use instead of master
function git_main_branch() {
  command git rev-parse --git-dir &>/dev/null || return
  local branch
  for branch in main trunk; do
    if command git show-ref -q --verify refs/heads/$branch; then
      echo $branch
      return
    fi
  done
  echo master
}

alias ga="git add"
alias gaa="git add --all"
alias gapa="git add --patch"

alias gb="git branch"
alias gba="git branch -a"
alias gbD="git branch -D"

alias gc!="git commit --amend"
alias gcn!="git commit --amend --no-edit"
alias gcmsg="git commit -m"
alias gcm="git checkout $(git_main_branch)"
alias gcd="git checkout develop"
alias gcb="git checkout -b"
alias gco="git checkout"
alias gcp="git cherry-pick"
alias gcpa="git cherry-pick --abort"
alias gcpc="git cherry-pick --continue"

alias gd="git diff"
alias gds="git diff --staged"

alias gf="git fetch"

alias gl="git pull"

alias gm="git merge"
alias gmom="git merge $(git_main_branch)"

alias gp="git push"
alias gpf!="git push --force"

alias gr="git remote"
alias gra="git remote add"
alias grb="git rebase"
alias grba="git rebase --abort"
alias grbc="git rebase --continue"
alias grbd="git rebase develop"
alias grbi="git rebase -i"
alias grbm="git rebase $(git_main_branch)"
alias grbs="git rebase --skip"
alias grm="git rm"
alias grs="git restore"
alias grst="git restore --staged"
alias grsh1="git restore --soft HEAD~1"
alias grv="git remote -v"

alias gst="git status"
alias gsps="git show --pretty=short --show-signature"

alias gstaa="git stash apply"
alias gstc="git stash clear"
alias gstl="git stash clear"
alias gstall="git stash --all"

# Bundler
alias be="bundle exec"
alias bers="bundle exec rspec --format documentation"

# Jekyll
alias jeks="bundle exec jekyll serve -w --force_polling"

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
alias deploy-stage="saml-monolith ibotta_cli application deploy api-server name:mcnoche --revision=$(git branch | grep \* | cut -d ' ' -f2)"

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

#!/bin/sh

# create a timestamp alias for the commit message
timestamp() {
  date +"%Y-%m-%d @ %T"
}

# files to backup
cp /Users/jesse.spevack/.zshrc /Users/jesse.spevack/codes/dotfiles/zshrc
cp /Users/jesse.spevack/.asdfrc /Users/jesse.spevack/codes/dotfiles/asdfrc
cp /Users/jesse.spevack/.gitconfig /Users/jesse.spevack/codes/dotfiles/gitconfig

cd /Users/jesse.spevack/codes/dotfiles

# pull & push
if [[ `git status --porcelain` ]]; then
    git pull origin main
    git add .
    git commit -m "Update: $(timestamp)"
    git push origin main
fi
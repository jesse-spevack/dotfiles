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

echo "job started: $(timestamp)" > log.txt

# pull & push
if [[ `git status --porcelain` ]]; then
  echo "Running Git commands: $(timestamp)" >> log.txt
  git pull origin main 2>&1 | tee -a log.txt
  git add . 2>&1 | tee -a log.txt
  git commit -m "Update: $(timestamp)" 2>&1 | tee -a log.txt
  git push origin main 2>&1 | tee -a log.txt
  echo "Finished running Git commands: $(timestamp)" >> log.txt
fi

echo "job done: $(timestamp)" >> log.txt
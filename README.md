# Jesse Spevack's Dotfiles

Modern dotfiles managed with GNU Stow for easy installation and maintenance across machines.

## What's Included

- **zsh** - Zsh shell configuration
- **git** - Git configuration and global ignore file
- **tmux** - tmux terminal multiplexer with Catppuccin theme
- **nvim** - Neovim with LazyVim setup
- **ghostty** - Ghostty terminal emulator
- **starship** - Cross-shell prompt
- **ssh** - SSH client configuration

## Prerequisites

- [GNU Stow](https://www.gnu.org/software/stow/)
- Git

### Install GNU Stow

**macOS:**
```bash
brew install stow
```

**Linux (Debian/Ubuntu):**
```bash
sudo apt install stow
```

## Installation

### Fresh Install

1. Clone this repository:
```bash
git clone https://github.com/jesse-spevack/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

2. Install all packages:
```bash
stow zsh git tmux nvim ghostty starship ssh
```

Or install packages selectively:
```bash
stow zsh git nvim
```

### Existing Dotfiles

If you already have dotfiles in place, you'll need to back them up or remove them first:

```bash
# Backup existing configs
mv ~/.zshrc ~/.zshrc.backup
mv ~/.gitconfig ~/.gitconfig.backup
# etc...

# Then run stow
cd ~/dotfiles
stow zsh git
```

## How GNU Stow Works

GNU Stow creates symlinks from this repo to your home directory. For example:

```
~/dotfiles/zsh/.zshrc  →  ~/.zshrc
~/dotfiles/nvim/.config/nvim/  →  ~/.config/nvim/
```

This means you can edit files directly in your home directory, and changes are automatically tracked in the git repo.

## Making Changes

1. Edit your config files as normal (e.g., `~/.zshrc`)
2. Changes are immediately reflected in the repo
3. Commit and push:
```bash
cd ~/dotfiles
git add .
git commit -m "Update zsh config"
git push
```

## Uninstalling

To remove symlinks for a package:
```bash
cd ~/dotfiles
stow -D zsh  # Removes zsh symlinks
```

## Setting Up a New Machine

1. Clone the repo
2. Install GNU Stow
3. Run `stow` for the packages you want
4. Done!

## Package Structure

Each directory represents a "package" that mirrors your home directory structure:

```
dotfiles/
├── zsh/
│   └── .zshrc
├── nvim/
│   └── .config/
│       └── nvim/
│           └── init.lua
└── git/
    ├── .gitconfig
    └── .config/
        └── git/
            └── ignore
```

## Notes

- SSH keys are not tracked (see `.gitignore`)
- Generated files like `lazy-lock.json` are excluded
- Old dotfiles from previous setup are in `old/` directory

## Resources

- [GNU Stow Manual](https://www.gnu.org/software/stow/manual/)
- [Managing Dotfiles with GNU Stow](https://brandon.invergo.net/news/2012-05-26-using-gnu-stow-to-manage-your-dotfiles.html)

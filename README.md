# Jesse Spevack's Dotfiles

Handle secret info with: [this](https://github.com/onyxraven/zsh-osx-keychain)

Enable the .sh to run by:
1. Open [crontab](http://crontab.org/) `crontab -e`
2. Add `0 9 * * MON cd ~/codes/dotfiles && ./backup_dotfiles.sh` to run the backup_dotfiles script on Monday at 9 am. See [Crontab.guru](https://crontab.guru/#*_*_*)

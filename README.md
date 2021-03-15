# Jesse Spevack's Dotfiles

Handle secret info with: [this](https://github.com/onyxraven/zsh-osx-keychain)

Enable the .sh to run by:
1. Open [crontab](http://crontab.org/) `crontab -e`
2. Add `0 9 * * MON cd ~/codes/dotfiles && ./backup_dotfiles.sh` to run the backup_dotfiles script on Monday at 9 am. See [Crontab.guru](https://crontab.guru/#*_*_*). Not crontab can be kind of finicky. I had to define the `PATH` for crontab, which I did with this [script](https://github.com/ssstonebraker/braker-scripts/blob/master/working-scripts/add_current_shell_and_path_to_crontab.sh) which I found in this [stack overflow](https://stackoverflow.com/questions/2388087/how-to-get-cron-to-call-in-the-correct-paths). I also had to make sure that the git repo was set up with SSH, which I did with help from [this gist](https://gist.github.com/developius/c81f021eb5c5916013dc)

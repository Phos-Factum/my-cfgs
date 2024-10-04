# Use powerline
USE_POWERLINE="true"
# Has weird character width
# Example:
#    is not a diamond
HAS_WIDECHARS="false"
# Source manjaro-zsh-configuration
if [[ -e /usr/share/zsh/manjaro-zsh-config ]]; then
  source /usr/share/zsh/manjaro-zsh-config
fi
# Use manjaro zsh prompt
if [[ -e /usr/share/zsh/manjaro-zsh-prompt ]]; then
  source /usr/share/zsh/manjaro-zsh-prompt
fi
# Starting tmux
if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
  exec tmux
fi

### Exports ###

export EDITOR=/usr/bin/vim


### Aliases ###

# Commands
alias rmrf='rm -rf'
alias rd='rmdir'
alias lla='ls -la'
alias ll='ls -l'
alias la='ls -a'
alias l='ls'
alias c='cd'
alias c..='cd ..'
alias c/='cd /'
alias c-='cd -'
alias s='cat'
alias md='mkdir'
alias m='mv'
alias s!='sudo !!'
alias dcd='cd /etc/systemd/system/; ls'
alias dls='ls /etc/systemd/system/'

# Configs
alias zshrc='vim ~/.zshrc; source ~/.zshrc'
alias bashrc='vim ~/.bashrc; source ~/.bashrc'
alias tmuxrc='vim ~/.tmux.conf; source ~/.tmux.conf'

# Package managers
alias yi='yay -S'
alias yu='yay -Syu'
alias yd='yay -Rs'
alias ydc='yay -Rns'
alias pi='sudo pacman -S'
alias pu='sudo pacman -Syu'
alias pd='sudo pacman -Rs'
alias pdc='sudo pacman -Rns'

# Daemons
alias dreload='sudo systemctl daemon-reload'
alias dstart='sudo systemctl start'
alias dstatus='sudo systemctl status'
alias denable='sudo systemctl enable'
alias ddisable='sudo systemctl disable'

# Utilities
alias uz='tar -xzf'
alias wifi='nmcli dev wifi connect'

# Office 
alias writer='loffice'
alias impress='loimpress'
alias calc='localc'
alias math='lomath'
alias base='lobase'
alias draw='lodraw'
alias pdf='zathura'

## Git
alias gita='git add'
alias gita.='git add .'
alias gitd='git diff'
alias gitb='git branch'
alias gitc='git commit'
alias gitc-m='git commit -m'
alias gitc--amend='git commit --amend'
alias gits='git status'
#
alias gitlog='git log'
alias gitrm='git rm'
alias gitmv='git mv'
alias gitclean='git clean'
alias gitpush='git push'
alias gitfpush='git push -f'
alias gitpull='git pull'
alias gitsw='git switch'
alias gitch='git checkout'

# Python
alias py='python3'
alias newvenv='python3 -m venv .venv'
alias actvenv='source .venv/bin/activate'

# Else
alias make='make; make clean'  # makefiles make and clean at one action

### Paths ###

PATH=${PATH}:~/.bin
export PATH

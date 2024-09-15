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


### Aliases ###

# Commands
alias rmrf='rm -rf'
alias lla='ls -la'
alias ll='ls -l'
alias la='ls -a'
alias md='mkdir'

# Configs
alias zshrc='vim ~/.zshrc; source ~/.zshrc'
alias bashrc='vim ~/.bashrc; source ~/.bashrc'
alias tmuxrc='vim ~/.tmux.conf; source ~/.tmux.conf'

# Package managers
alias yi='yay -S'
alias yu='yay -Syu'
alias pi='sudo pacman -S'
alias pu='sudo pacman -Syu'

# Daemons
alias dreload='sudo systemctl daemon-reload'
alias dstart='sudo systemctl start'
alias dstatus='sudo systemctl status'
alias denable='sudo systemctl enable'
alias ddisable='sudo systemctl disable'


### Paths ###
PATH=${PATH}:~/.bin
export PATH

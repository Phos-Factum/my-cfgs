#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

colors() {
    local fgc bgc vals seq0

    printf "Color escapes are %s\n" '\e[${value};...;${value}m'
    printf "Values 30..37 are \e[33mforeground colors\e[m\n"
    printf "Values 40..47 are \e[43mbackground colors\e[m\n"
    printf "Value  1 gives a  \e[1mbold-faced look\e[m\n\n"

    # foreground colors
    for fgc in {30..37}; do
        # background colors
        for bgc in {40..47}; do
            fgc=${fgc#37} # white
            bgc=${bgc#40} # black

            vals="${fgc:+$fgc;}${bgc}"
            vals=${vals%%;}

            seq0="${vals:+\e[${vals}m}"
            printf "  %-9s" "${seq0:-(default)}"
            printf " ${seq0}TEXT\e[m"
            printf " \e[${vals:+${vals+$vals;}}1mBOLD\e[m"
        done
        echo
        echo
    done
}

[ -r /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion

# Change the window title of X terminals
case ${TERM} in
xterm* | rxvt* | Eterm* | aterm | kterm | gnome* | interix | konsole*)
    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\007"'
    ;;
screen*)
    PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\033\\"'
    ;;
esac

use_color=true

# Set colorful PS1 only on colorful terminals.
# dircolors --print-database uses its own built-in database
# instead of using /etc/DIR_COLORS.  Try to use the external file
# first to take advantage of user additions.  Use internal bash
# globbing instead of external grep binary.
safe_term=${TERM//[^[:alnum:]]/?} # sanitize TERM
match_lhs=""
[[ -f ~/.dir_colors ]] && match_lhs="${match_lhs}$(<~/.dir_colors)"
[[ -f /etc/DIR_COLORS ]] && match_lhs="${match_lhs}$(</etc/DIR_COLORS)"
[[ -z ${match_lhs} ]] &&
    type -P dircolors >/dev/null &&
    match_lhs=$(dircolors --print-database)
[[ $'\n'${match_lhs} == *$'\n'"TERM "${safe_term}* ]] && use_color=true

if ${use_color}; then
    # Enable colors for ls, etc.  Prefer ~/.dir_colors #64489
    if type -P dircolors >/dev/null; then
        if [[ -f ~/.dir_colors ]]; then
            eval $(dircolors -b ~/.dir_colors)
        elif [[ -f /etc/DIR_COLORS ]]; then
            eval $(dircolors -b /etc/DIR_COLORS)
        fi
    fi

    if [[ ${EUID} == 0 ]]; then
        PS1='\[\033[01;31m\][\h\[\033[01;36m\] \W\[\033[01;31m\]]\$\[\033[00m\] '
    else
        PS1='\[\033[01;32m\][\u@\h\[\033[01;37m\] \W\[\033[01;32m\]]\$\[\033[00m\] '
    fi

    alias ls='ls --color=auto'
    alias grep='grep --colour=auto'
    alias egrep='egrep --colour=auto'
    alias fgrep='fgrep --colour=auto'
else
    if [[ ${EUID} == 0 ]]; then
        # show root@ when we don't have colors
        PS1='\u@\h \W \$ '
    else
        PS1='\u@\h \w \$ '
    fi
fi

unset use_color safe_term match_lhs sh

### Exports ###

export EDITOR=/usr/bin/vim

##### Aliases #####

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
alias z='nvim ~/.zshrc; source ~/.zshrc; zshcp'
alias bashrc='nvim ~/.bashrc; source ~/.bashrc; bashcp'
alias tmuxrc='nvim ~/.tmux.conf; source ~/.tmux.conf'

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
alias vpnon='adguardvpn-cli connect'
alias vpnoff='adguardvpn-cli disconnect'
alias vpn='adguardvpn-cli status'

##  Utilities ##
alias ph='viewnior'
alias gdb='gdb -x ~/.gdbinit'
alias g='gdb'
alias nd='nodemon'

# Pomodoro
alias p='pomodoro'
alias pstart='pomodoro start --duration'
alias pstop='pomodoro finish'
alias pcan='pomodoro cancel'
alias pstatus='pomodoro status'
alias pbreak='pomodoro break'
alias prepeat='pomodoro repeat'

################

# Office
alias writer='loffice'
alias impress='loimpress'
alias calc='localc'
alias math='lomath'
alias base='lobase'
alias draw='lodraw'
alias pdf='zathura'

## Git ##

# Git (short)
alias gita='git add'
alias gita.='git add .'
alias gitd='git diff'
alias gitb='git branch'
alias gitc='git commit'
alias gitc-m='git commit -m'
alias gitc--amend='git commit --amend'
alias gits='git status'

# Git (less short :D)
alias gitlog='git log'
alias gitrm='git rm'
alias gitmv='git mv'
alias gitclean='git clean'
alias gitpush='git push'
alias gitfpush='git push -f'
alias gitpull='git pull'
alias gitsw='git switch'
alias gitch='git checkout'

#########

# Python
alias py='python3'
alias newvenv='python3 -m venv .venv'
alias actvenv='source .venv/bin/activate'

# System utilities
alias chx='chmod +x'   # won't work on local user's cfg
alias ch37='chmod 777' # same
alias um='uname -m'
alias du='du -h'
alias free='free -m'
alias untar='tar -zxvf'
alias wifi='nmcli dev wifi connect'

# Else
alias mc='make; make clean' # makefiles make and clean at one action
alias moc='make clean'      # make only clean

# Lmao aliases
alias zshcp='cp ~/.zshrc ~/.my-cfgs/Shell/'
alias bashcp='cp ~/.bashrc ~/.my-cfgs/Shell/'
alias shellcp='zshcp; bashcp'

# Books
alias book_stolyarov1='zathura ~/Education/Materials/Books/progintro_e2v1.pdf'
alias book_stolyarov2='zathura ~/Education/Materials/Books/progintro_e2v2.pdf'
alias book_stolyarov3='zathura ~/Education/Materials/Books/progintro_e2v3.pdf'
alias book_swaroop='zathura ~/Education/Materials/Books/swaroop-byte_of_python.pdf'
alias book_msu='zathura ~/Education/Materials/Books/msu-python_oop.pdf'

# My custom scripts
alias saveit='cat >> ~/Education/Materials/Saved_Links'

### Paths ###

PATH=${PATH}:~/.bin
export PATH

# Pomodoro #
function pomo() {
    arg1=$1
    shift
    args="$*"

    min=${arg1:?Example: pomo 15 Take a break}
    sec=$((min * 60))
    msg="${args:?Example: pomo 15 Take a break}"

    while true; do
        sleep "${sec:?}" && echo "${msg:?}" && notify-send -u critical -t 0 "${msg:?}"
    done
}

xhost +local:root >/dev/null 2>&1

# Bash won't get SIGWINCH if another process is in the foreground.
# Enable checkwinsize so that bash will check the terminal size when
# it regains control.  #65623
# http://cnswww.cns.cwru.edu/~chet/bash/FAQ (E11)
shopt -s checkwinsize

shopt -s expand_aliases

# export QT_SELECT=4

# Enable history appending instead of overwriting.  #139609
shopt -s histappend

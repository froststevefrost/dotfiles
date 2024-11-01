# Make `ls' colorized
 export LS_OPTIONS='--color=auto --group-directories-first'
 eval "`dircolors`"
 alias ls='ls $LS_OPTIONS'
 alias ll='ls $LS_OPTIONS -hAlF'
 alias l='ls $LS_OPTIONS -lA'

alias vi="vim"

# Some more alias to avoid making mistakes:
 alias rm='rm -i'
 alias cp='cp -i'
 alias mv='mv -i'

# grep colors
 alias grep='grep --color=always'
 alias egrep='egrep --color=always'
 alias fgrep='fgrep --color=always'

# QoL aliases 
 alias update='sudo apt update && sudo apt upgrade'
 alias lsblk='lsblk -e 7'
 alias editbash='vim ~/.bashrc && . ~/.bashrc'
 alias editalias='vim ~/.bash_aliases && . ~/.bash_aliases'
 alias pi='ssh steve@pihole'
 alias nas='ssh steve@frost-nas'
 alias clear='clear; printf "\n\t\t${RED}Some aliases:${NC}\n"; alias | grep -vE "cp|\sl[a-z]|mv|rm|\sl=|vi=|clear|grep=" | sed "s/alias //g" | cut -d"=" -f1 | pr -2 -t; echo ""'

# Set default umask
 umask 022

# Color variables
 NC='\033[0m'
RED='\033[0;31m'
GRN='\033[0;32m'

# Include the /opt directory in PATH
export PATH=$PATH:/opt

if [ -f ~/.bash_aliases ]
    then
            source ~/.bash_aliases
fi

if [ -f ~/.bash_functions ]
    then
        source ~/.bash_functions
fi

# Print all aliases at the top of the terminal
printf "\n\t\t${RED}Some aliases:${NC}\n"; alias | grep -vE "grep=|cp|\sl[a-z]|mv|rm|\sl=|vi=" | sed 's/alias //g' | cut -d'=' -f1 | pr -2 -t; echo ""

# Auto change directory when typing dirs
shopt -s autocd

# Make history infinite
HISTSIZE= HISTFILESIZE=

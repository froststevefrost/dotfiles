# Set default umask
 umask 027

# Color variables
NC='\033[0m'
RED='\033[0;31m'
GRN='\033[0;32m'

# Include the /opt directory in PATH
export PATH=$PATH:/opt

[[ -f ~/.bash_aliases ]] && source ~/.bash_aliases
[[ -f ~/.bash_functions ]] && source ~/.bash_functions

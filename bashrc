### cc <arguments to gcc> -- Invokes gcc with the flags you will usually use
### valgrind-leak <arguments to valgrind> -- Invokes valgrind in the mode to show all leaks
### hidden <arguments to ls> -- Displays ONLY the hidden files
### killz <program name> -- Kills all programs with the given program name
### shell -- Displays the name of the shell being used
### + more that need to be undocumented

# ----- guard against non-interactive logins ---------------------------------
[ -z "$PS1" ] && return

# Set default editor
export EDITOR="$(command -v vim)"


# Get OS type for OS specific commands
OS_RAW_NAME=$(uname)
if [[ ${OS_RAW_NAME} == "Darwin" ]]; then
    OS_NAME="Mac"
elif [[ ${OS_RAW_NAME} == "Linux" ]]; then
    OS_NAME="Linux"
else
    echo "~/.bashrc error: unknown OS type: ${OS_RAW_NAME}"
fi


# ----- shell settings and completion -------------------------------------

# Make .bash_history store more and not store duplicates
export HISTCONTROL=ignoredups
export HISTSIZE=250000
export HISTFILESIZE=250000

# Color support for ls and grep
# LSCOLORS is the Mac env variable that is used for color definitions
# LS_COLORS needs to be defined for linux tools like readline to look for colors there
#export CLICOLOR=1
#export LSCOLORS=exfxcxdxbxegedabagacad
#export LS_COLORS="di=34:ln=35:so=33;4:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43"

# Append to the history file, don't overwrite it
shopt -s histappend

# Check the window size after each command and, if necessary,
# Update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Type a directory name by itself to auto cd into it 
shopt -s autocd

# Enable recursive file/directory expansion
shopt -s globstar

# Enable immediate history expansion by pressing space
# ex. !-2<space> will immediately expand to two commands ago
bind Space:magic-space

# These didn't work in inputrc, but work in bashrc. Something is amiss.
bind 'set completion-ignore-case on'  # Ignore case when completing
bind 'set completion-map-case on'  # Treat hyphens and underscores as equivalent when completing
bind 'set colored-stats on' # Show colored file names on tab completion
bind 'set colored-completion-prefix on' # Color the prefix of the tab completion match so far (uses socket color def)

# Enable programmable completion features
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

# Make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe.sh ] && export LESSOPEN="|/usr/bin/lesspipe.sh %s"


# Load aliases and such
[ -f ~/.shell_aliasrc ] && source ~/.shell_aliasrc

# ----- change the prompt ----------------------------------------------------
# get current branch in git repo
function parse_git_branch() {
    BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
    if [ ! "${BRANCH}" == "" ]
    then
        STAT=`parse_git_dirty`
        echo "[${BRANCH}${STAT}]"
    else
        echo ""
    fi
}

# get current status of git repo
function parse_git_dirty {
    status=`git status 2>&1 | tee`
    dirty=`echo -n "${status}" 2> /dev/null | grep "modified:" &> /dev/null; echo "$?"`
    untracked=`echo -n "${status}" 2> /dev/null | grep "Untracked files" &> /dev/null; echo "$?"`
    ahead=`echo -n "${status}" 2> /dev/null | grep "Your branch is ahead of" &> /dev/null; echo "$?"`
    newfile=`echo -n "${status}" 2> /dev/null | grep "new file:" &> /dev/null; echo "$?"`
    renamed=`echo -n "${status}" 2> /dev/null | grep "renamed:" &> /dev/null; echo "$?"`
    deleted=`echo -n "${status}" 2> /dev/null | grep "deleted:" &> /dev/null; echo "$?"`
    bits=''
    if [ "${renamed}" == "0" ]; then
        bits=">${bits}"
    fi
    if [ "${ahead}" == "0" ]; then
        bits="*${bits}"
    fi
    if [ "${newfile}" == "0" ]; then
        bits="+${bits}"
    fi
    if [ "${untracked}" == "0" ]; then
        bits="?${bits}"
    fi
    if [ "${deleted}" == "0" ]; then
        bits="x${bits}"
    fi
    if [ "${dirty}" == "0" ]; then
        bits="!${bits}"
    fi
    if [ ! "${bits}" == "" ]; then
        echo " ${bits}"
    else
        echo ""
    fi
}
RESET="\[\033[0m\]"
RED="\[\033[0;31m\]"
GREEN="\[\033[01;32m\]"
WHITE="\[\033[01;34m\]"
DARK_YELLOW="\[\033[0;33m\]"
YELLOW="\e[32m\]"
BLUE="\[\e[34m\]"
MAGENTA="\[\e[35m\]"

function parse_git_branch_simple {
  PS_BRANCH=''
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  PS_BRANCH="(${ref#refs/heads/}) "
} 

# Prints a newline before the prompt in order to put virtualenvs above the 
#   actual prompt.
function needs_extra_NL() {
    if [[ -n $VIRTUAL_ENV ]] || [[ -n $CONDA_DEFAULT_ENV ]]; then
        echo -e "\n\r"
    fi
}

# Easier way to add the newline before the bash promopt instead of having
#   to modify virtualenv things
# history -a appends the history from this shell, which is useful if you 
#   have multiple shells open, so that a new shell will then have access to 
#   all of the previous multiple shell's commands
PROMPT_COMMAND="printf '\n';history -a;parse_git_branch_simple;"
PS_EXTRA_NL="\$(needs_extra_NL)"
PS_INFO="${YELLOW}\u${RESET}@${BLUE}\h${RESET}:\w"
PS_GIT="${DARK_YELLOW}\${PS_BRANCH}"
PS_TIME="\[\033[\$((COLUMNS-16))G\] ${RED}[\D{%m/%d} \t]"
export PS1="${PS_EXTRA_NL}${PS_INFO} ${PS_GIT}${PS_TIME}\n${RESET}\$ "



# '\n\e[0;34m\u@\h:\w$ \e[m'
#export PS1="\n\[\e[32m\]\u\[\e[m\]@\[\e[34m\]\h\[\e[m\]:\[\e[36m\]\w\[\e[m\]\[\e[33m\]\[\e[m\]\[\e[37;40m\]\\$\[\e[m\] "
# export PS1="\[\e[32m\]\u\[\e[m\]:\[\e[36m\]\w\[\e[m\]\[\e[33m\]\`parse_git_branch\`\[\e[m\]\[\e[37;40m\]\\$\[\e[m\] "


#export TERM=screen-256color
#export TERM=xterm-256color


# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Library/google-cloud-sdk/path.bash.inc' ]; then source '/Library/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Library/google-cloud-sdk/completion.bash.inc' ]; then source '/Library/google-cloud-sdk/completion.bash.inc'; fi

# Using eval bc it makes nvm load faster
export NVM_DIR="$HOME/.nvm"
eval [ -s "$NVM_DIR/nvm.sh" ] && eval \. "$NVM_DIR/nvm.sh"  # This loads nvm
eval [ -s "$NVM_DIR/bash_completion" ] && eval \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


if [[ -d ~/.local/ok-bash/ ]]; then
    source ~/.local/ok-bash/ok.sh prompt prompt_default
fi

# Load fzf
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"


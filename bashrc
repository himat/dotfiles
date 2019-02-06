# ----- Andrew server special commands courtesy of GPI ----------------------
### afsperms <arguments to fs sa> -- Recursively runs fs sa on a directory
### cc <arguments to gcc> -- Invokes gcc with the flags you will usually use
### valgrind-leak <arguments to valgrind> -- Invokes valgrind in the mode to show all leaks
### hidden <arguments to ls> -- Displays ONLY the hidden files
### killz <program name> -- Kills all programs with the given program name
### shell -- Displays the name of the shell being used
### get_cs_afs_access -- Sets up cross-realm authentication with CS.CMU.EDU so you can access files stored there.

# ----- guard against non-interactive logins ---------------------------------
[ -z "$PS1" ] && return

# ----- Start in the last directory you were in ------------------------------

# Move to the last saved working directory if one exists
if [ -e ~/.last_cd ]
then
    cd "$(cat ~/.last_cd)"
fi

# Saves current directory between sessions
unalias cd 2>/dev/null # Prevent infinite loops if sourcing this file again in the same session
logged_cd() {
    cd "$@"
    pwd > ~/.last_cd
}

alias "cd"="logged_cd" # keep track of most recent directory 
alias "cdb"="cd ~-" # cd to previous directory
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias ..2="cd ../.."
alias ..3="cd ../../.."
alias ..4="cd ../../../.."
alias ..5="cd ../../../../.."
alias cd..="cd .."
alias cd...="cd ../.."
alias cd....="cd ../../.."
alias cd.....="cd ../../../.."
alias cd......="cd ../../../../.."

# Get OS type for OS specific commands
OS_RAW_NAME=$(uname)
if [[ ${OS_RAW_NAME} == "Darwin" ]]; then
    OS_NAME="Mac"
elif [[ ${OS_RAW_NAME} == "Linux" ]]; then
    OS_NAME="Linux"
else
    echo "~/.bashrc error: unknown OS type: ${OS_RAW_NAME}"
fi

tmux_clear() {
    if [ -n "$TMUX" ]; then
        clear
        tmux clear-history
    else
        clear
    fi
}
alias "clear"="tmux_clear"

# Use vim keybindings in the terminal!
#set -o vi

# ----- convenient alias and function definitions ----------------------------

# ls uses colors, shows human-readable file sizes, shows indicators to classify file types
if [[ ${OS_NAME} == "Linux" ]]; then 
    alias ls='ls --color=auto --human-readable --classify'
elif [[ ${OS_NAME} == "Mac" ]]; then
    alias ls='ls -G -h -F'
fi
alias ll='ls -l'
alias llt='ls -lt'
alias grep='grep --color=auto'

alias killz='killall -9 '
alias hidden='ls -a | grep "^\..*"'
alias rm='rm -v'
alias cp='cp -v'
alias mv='mv -v'
alias shell='ps -p $$ -o comm='
alias sml='rlwrap sml'
alias math='rlwrap MathKernel'
alias coin='rlwrap coin'

alias cc='gcc -Wall -W -ansi -pedantic -O2 '
alias valgrind-leak='valgrind --leak-check=full --show-reachable=yes'

# connects to existing session if one exists, else creates a new one
alias tm='tmux attach || tmux' 
alias tmls='tmux ls'

# Usage: sa <venv>
alias sa='source activate'
alias sd='source deactivate'

# Shows the diff from before a pull and after
# Can also do things like master@{10 minutes ago} and such
alias gitdiffpull='git diff master@{1} master'

find_recent_modified_files() {

    if [[ -z $1 ]]; then
        IGNORE_HIDDEN_FILES=false
    elif [[ $1 == "--ignore-hidden" ]]; then
        IGNORE_HIDDEN_FILES=true
    else
        echo "Invalid argument. Supported options are: '--ignore-hidden'."
        return 1
    fi

    if [[ ${OS_NAME} == "Mac" ]]; then
        if [[ ${IGNORE_HIDDEN_FILES} == "true" ]]; then
            find . -not -path '*/\.*' -exec stat -f '%m%t%Sm %N' {} + | sort -nr | cut -f2- | head -n10
        else
            find . -exec stat -f '%m%t%Sm %N' {} + | sort -nr | cut -f2- | head -n10
        fi

    elif [[ ${OS_NAME} == "Linux" ]]; then
        if [[ ${IGNORE_HIDDEN_FILES} == "true" ]]; then
            find . -type f -not -path '*/\.*' -print0 | xargs -0 stat --format '%Y :%y %n' | sort -nr | cut -d: -f2- | head
        else
            find . -type f -print0 | xargs -0 stat --format '%Y :%y %n' | sort -nr | cut -d: -f2- | head
        fi

    fi
}

alias mods="find_recent_modified_files"

afsperms(){ find $1 -type d -exec fs sa {} $2 $3 \; ; }
get_cs_afs_access() {
    # Script to give a user with an andrew.cmu.edu account access to cs.cmu.edu
    # See https://www.cs.cmu.edu/~help/afs/cross_realm.html for information.

    # Get tokens. This might create the user, but I'm not sure that that's
    # reliable, so we'll also try to do pts createuser.
    aklog cs.cmu.edu

    pts createuser $(whoami)@ANDREW.CMU.EDU -cell cs.cmu.edu 2>&1 | grep -v "Entry for name already exists"

    aklog cs.cmu.edu

    echo "Be sure to add aklog cs.cmu.edu & to your ~/.bashrc"
}

function runrm(){
python /afs/cs.cmu.edu/academic/class/15251-s16/rmprogramming/runrm.pyc $@
}

# ----- shell settings and completion -------------------------------------

# Make .bash_history store more and not store duplicates
export HISTCONTROL=ignoredups
export HISTSIZE=250000
export HISTFILESIZE=250000

# Color support for ls and grep
# LSCOLORS is the Mac env variable that is used for color definitions
# LS_COLORS needs to be defined for linux tools like readline to look for colors there
export CLICOLOR=1
export LSCOLORS=exfxcxdxbxegedabagacad
export LS_COLORS="di=34:ln=35:so=33;4:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43"

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
PS_INFO="$YELLOW\u$RESET@$BLUE\h$RESET:\w"
PS_GIT="$DARK_YELLOW\$PS_BRANCH"
PS_TIME="\[\033[\$((COLUMNS-16))G\] $RED[\D{%m/%d} \t]"
export PS1="${PS_EXTRA_NL}${PS_INFO} ${PS_GIT}${PS_TIME}\n${RESET}\$ "



# '\n\e[0;34m\u@\h:\w$ \e[m'
#export PS1="\n\[\e[32m\]\u\[\e[m\]@\[\e[34m\]\h\[\e[m\]:\[\e[36m\]\w\[\e[m\]\[\e[33m\]\[\e[m\]\[\e[37;40m\]\\$\[\e[m\] "
# export PS1="\[\e[32m\]\u\[\e[m\]:\[\e[36m\]\w\[\e[m\]\[\e[33m\]\`parse_git_branch\`\[\e[m\]\[\e[37;40m\]\\$\[\e[m\] "

# ----- local configuration ----------------------------------------------------
# Put settings that should be there for each local machine in ~/.bashrc.extra
    # so that local preferences aren't pushed to the git repo 
if [[ -f ~/.bashrc.extra ]]; then
    source ~/.bashrc.extra
fi

#export TERM=screen-256color
export TERM=xterm-256color


# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Library/google-cloud-sdk/path.bash.inc' ]; then source '/Library/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Library/google-cloud-sdk/completion.bash.inc' ]; then source '/Library/google-cloud-sdk/completion.bash.inc'; fi

# Using eval bc it makes nvm load faster
export NVM_DIR="~/.nvm"
eval [ -s "$NVM_DIR/nvm.sh" ] && eval \. "$NVM_DIR/nvm.sh"  # This loads nvm
eval [ -s "$NVM_DIR/bash_completion" ] && eval \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


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
unalias cd # Prevent infinite loops if sourcing this file again in the same session
logged_cd() {
    cd "$@"
    pwd > ~/.last_cd
}

alias "cd"="logged_cd" # keep track of most recent directory 

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

# ----- convenient alias and function definitions ----------------------------

# color support for ls and grep
export CLICOLOR=1
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
export HISTCONTROL=ignoreboth
export HISTSIZE=250000
export HISTFILESIZE=250000

# Append to the history file, don't overwrite it
shopt -s histappend

# Check the window size after each command and, if necessary,
# Update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Enable programmable completion features
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

bind "set completion-ignore-case on"

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
# '\n\e[0;34m\u@\h:\w$ \e[m'
export PS1="\n\[\e[32m\]\u\[\e[m\]@\[\e[34m\]\h\[\e[m\]:\[\e[36m\]\w\[\e[m\]\[\e[33m\]\[\e[m\]\[\e[37;40m\]\\$\[\e[m\] "
# export PS1="\[\e[32m\]\u\[\e[m\]:\[\e[36m\]\w\[\e[m\]\[\e[33m\]\`parse_git_branch\`\[\e[m\]\[\e[37;40m\]\\$\[\e[m\] "
# PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

# ----- local configuration ----------------------------------------------------
# Put settings that should be there for each local machine in ~/.bashrc.extra
    # so that local preferences aren't pushed to the git repo 
if [[ -f ~/.bashrc.extra ]]; then
    source ~/.bashrc.extra
fi


#BASE16_SHELL="$HOME/.config/base16-shell/base16-default.dark.sh"
#[[ -s $BASE16_SHELL ]] && source $BASE16_SHELL

export TERM=screen-256color


# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Library/google-cloud-sdk/path.bash.inc' ]; then source '/Library/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Library/google-cloud-sdk/completion.bash.inc' ]; then source '/Library/google-cloud-sdk/completion.bash.inc'; fi

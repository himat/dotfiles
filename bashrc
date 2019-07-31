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

# Set default editor
export EDITOR="$(command -v vim)"

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
alias l='ls'
alias la='ls -A'
alias ll='ls -l'
alias llt='ls -lt'
alias l.="ls -A | egrep '^\.'" # List only hidden files

alias grep='grep --color=auto'
alias lgrep="ls -AF | grep"

alias killz='killall -9 '
alias hidden='ls -a | grep "^\..*"'

# Use \command to run the unaliased version of any command
#   such as if you want to rm a large dir without it printing everything, use \rm
alias rm='rm -v'
alias cp='cp -v'
alias mv='mv -v'

alias shell='ps -p $$ -o comm='

alias cc='gcc -Wall -W -ansi -pedantic -O2 '
alias valgrind-leak='valgrind --leak-check=full --show-reachable=yes'

alias pdb='python -m pdb'

# Connect to existing session if one exists, else create a new one
tm() {
    num_sess=$(tmux list-session | wc -l)
    if [[ ${num_sess} -gt 1 && $# -ne 1 ]]; then
        echo "ERR: There are multiple tmux sessions, so call this function with an argument choosing the session number"
        echo "$(tmux list-session)"
        return 1
    elif [[ ${num_sess} -gt 1 && $# -eq 1 ]]; then
        tmux attach -t $1
    elif [[ ${num_sess} -eq 1 ]]; then
        tmux attach # Connect to existing session 
    else
        tmux # Make new session
    fi
}
alias tma="tmux attach" # Connect to default (last) session
alias tmls='tmux ls'

# Usage: CA <venv>
alias CA='conda activate'
alias CD='conda deactivate'

alias tb='tensorboard --logdir'

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
PS_INFO="${YELLOW}\u${RESET}@${BLUE}\h${RESET}:\w"
PS_GIT="${DARK_YELLOW}\${PS_BRANCH}"
PS_TIME="\[\033[\$((COLUMNS-16))G\] ${RED}[\D{%m/%d} \t]"
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

if [[ -d ~/.local/ok-bash/ ]]; then
    source ~/.local/ok-bash/ok.sh prompt prompt_default
fi

#export TERM=screen-256color
#export TERM=xterm-256color

# Call from cmdline as 'aws_profile <prof_name>' to switch the current aws cli profile
#   Profile names are found in ~/.aws/config
function aws_profile() {
    export AWS_PROFILE=$1
}

# AWS CLI utility functions
function hostname_from_instance() {
    aws ec2 describe-instances --filters "{\"Name\":\"tag:Name\", \"Values\":[\"$1\"]}" --query='Reservations[0].Instances[0].PublicDnsName' | tr -d '"'
}
function ip_from_instance() {
    name="$1"
    shift # Remove name from args list
    aws ec2 describe-instances --filters "{\"Name\":\"tag:Name\", \"Values\":[\"$name\"]}" --query='Reservations[0].Instances[0].PublicIpAddress' "$@" | tr -d '"'
}
# Call as 'ssh-aws <name>' with ' --region <reg-name>' if default region not set in aws-cli
#   Region can be anything like us-west-2 (don't put any sub-region letters since it won't work)
# TODO: Figure out how to pass ssh options like -Y and -L 6006:localhost:6006
function ssh-aws() { 
    ssh "ubuntu@$(ip_from_instance "$@")"

    if [[ $? == 255 ]]; then
        echo "If the machine name could not be resolved, verify that your aws cli profile is set to the correct user"
        return 255
    fi
}

# TODO: Figure out how a scp function from an ec2 name would be possible
# Maybe just parse for the string before a colon to find the name, and check that there is only one colon in the passed args
function scp-aws() {
    orig_cmd="$*"
    # Count NumFields with colons
    num_colons=$(echo "$orig_cmd" | awk -F: '{print NF-1}')

    if [[ $num_colons != 1 ]]; then
        echo "ERR: You must only have 1 colon in this scp command. Found: $num_colons."
        return 1
    fi
    echo "|$orig_cmd|"
   
    # TODO: region extraction doesn't work. 
    region=$(echo "$orig_cmd" | sed -E 's@^(.).*\s--region\s([\w,-]*).*$@\1\2@')
    #region=$(echo "$orig_cmd" | sed -E 's@^(.*\s|)(.*)(:.*$)@\1\2@')
    echo "r:$region"

    return 1

    # Extract word before the colon
    name_match_str='^(.*\s|)(.*)(:.*$)'
    name=$(echo "$orig_cmd" | sed -E 's/'"$name_match_str"'/\2/')

    echo "$name"

    ip=$(ip_from_instance "$name")

    echo "$ip"
    ip="43433"



    final_cmd=$(echo "$orig_cmd" | sed -E 's/'"$name_match_str"'/scp \1'"$ip"'\3/')
    echo "$final_cmd"
}

# Report port forwarding functions from https://superuser.com/questions/248389/list-open-ssh-tunnels/1437366#1437366
function ports_local_forwardings() {

  echo 
  echo "LOCAL PORT FORWARDING"
  echo
  echo "You set up the following local port forwardings:"
  echo

  lsof -a -i4 -P -c '/^ssh$/' -u$USER -s TCP:LISTEN

  echo
  echo "The processes that set up these forwardings are:"
  echo

  # -a ands the selection criteria (default is or)
  # -i4 limits to ipv4 internet files
  # -P inhibits the conversion of port numbers to port names
  # -c /regex/ limits to commands matching the regex
  # -u$USER limits to processes owned by $USER
  # http://man7.org/linux/man-pages/man8/lsof.8.html
  # https://stackoverflow.com/q/34032299
  ps -f -p $(lsof -t -a -i4 -P -c '/^ssh$/' -u$USER -s TCP:LISTEN)

}

function ports_remote_forwardings() {

  echo 
  echo "REMOTE PORT FORWARDING"
  echo
  echo "You set up the following remote port forwardings:"
  echo

  ps -f -p $(lsof -t -a -i -c '/^ssh$/' -u$USER -s TCP:ESTABLISHED) | awk '
  NR == 1 || /R [[:digit:]]+:\S+:[[:digit:]]+.*/
  '
}

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Library/google-cloud-sdk/path.bash.inc' ]; then source '/Library/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Library/google-cloud-sdk/completion.bash.inc' ]; then source '/Library/google-cloud-sdk/completion.bash.inc'; fi

# Using eval bc it makes nvm load faster
export NVM_DIR="~/.nvm"
eval [ -s "$NVM_DIR/nvm.sh" ] && eval \. "$NVM_DIR/nvm.sh"  # This loads nvm
eval [ -s "$NVM_DIR/bash_completion" ] && eval \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


# Load fzf
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

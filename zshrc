# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
# export PATH="/usr/local/opt/python/libexec/bin:$PATH"

# Path to your oh-my-zsh installation.
export ZSH="/Users/hima/.oh-my-zsh"

# Shows `less` output inline in the terminal if it's less than one page in length
#   Otherwise does the default of showing it in a paged view
export LESS="--no-init --quit-if-one-screen -R"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
#ZSH_THEME="robbyrussell"
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
 HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
 ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
#COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# [mine] Need to put this before zsh plugins get loaded so that when I use 
#   autojump to go to a dir (which uses cd) internally that it uses my logged_cd
#   since otherwise, it won't get saved
#   And I couldn't just source my entire ~/.sh_aliasrc file here because then
#   sourcing oh-my-zsh.sh alter overwrites some of the aliases like 'l'
#   So I just had to duplicate this single one here
# Saves current directory between sessions
unalias cd 2>/dev/null # Prevent infinite loops if sourcing this file again in the same session
logged_cd() {
    cd "$@"
    pwd > ~/.last_cd
}

alias "cd"="logged_cd" # keep track of most recent directory 

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-autosuggestions zsh-syntax-highlighting colorize autojump aws nvm)

source $ZSH/oh-my-zsh.sh
#source $HOME/.bash_profile

######################### User configuration ==============================

# [mine] Load aliases and such
[ -f ~/.sh_aliasrc ] && source ~/.sh_aliasrc

# By default it seems that oh-my-zsh auto share history between current 
# sesions, which is very annoying when using the up arrow key in terminal to 
# go to previous commands since it starts showing commands ran in other tabs, 
# which is not what I want unless I opened a new tab
setopt nosharehistory

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
 if [[ -n $SSH_CONNECTION ]]; then
   export EDITOR='vim'
 else
   export EDITOR='vim'
 fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"



#export CLICOLOR=1
#export LSCOLORS=exfxcxdxbxegedabagacad
#export LS_COLORS="di=94:ln=35:so=33;4:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43"
export LS_COLORS=$LS_COLORS:'di=34:'

prompt_context(){} # For agnoster zsh theme, don't show hostname when you're on local machine

# Load p10k zsh theme (the most amazing theme ever)
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

##


# Binds Ctrl-Enter to use and execute the shown zsh autosuggestion
# Note that for this to work you first need to send the escape sequence 
#   [[CE when Ctrl-Enter is pressed in yur iterm settings
bindkey '^[[[CE' autosuggest-execute

# Use tab for autosuggest history completion, and shift+tab for regular completion
# (make sure to disable auto-completion import in ~/.fzf.zsh so that we can bind the tab-key here)
bindkey '^I'      autosuggest-accept # C-I === tab key
bindkey '^E'     forward-word
# bindkey '^[[Z' autosuggest-accept  # shift + tab  | autosuggest

ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=(buffer-empty bracketed-paste accept-line push-line-or-edit)
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_USE_ASYNC=true

# Map C-8 and C-7 to go up and down the history same as the arrow keys
# But these should be easier so that I don't have to move my hands all the way to the arrow keys
# Note: I couldn't use C-K/J because I use those for moving between tmux panes already
# - And I couldn't use C-I/U because C-I and <Tab> send the same key codes in terminals, so you can't distinguish between them
# Needed to import this history-search-end zle lib to get the correct functionality
autoload -Uz history-search-end
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
# bindkey '^I' history-beginning-search-backward-end
# NOTE: This requires setting up your iterm to map ctrl-9/8 to send these specific escape sequences
bindkey '^[[[ctrl9' up-line-or-beginning-search
bindkey '^[[[ctrl8' down-line-or-beginning-search
# bindkey '^U' history-beginning-search-backward-end
# bindkey '^U' down-line-or-beginning-search
# bindkey ';' history-beginning-search-backward

##########################
# TODO: source bashrc file after moving bash specific things into a bash_profile or other bash file, and just keep bashrc for things that can be shared between zshrc and bashrc in cases where I don't have zsh installed yet like on a remote server, so whenever I add new bash/zsh aliases, I just always add them in the bashrc, so that I'll have access to both no matter if I'm using bash or zsh. Once that's done, remove the below since they're copied from my bashrc.

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

alias g='git'
alias gi='git'
alias v='vim'
alias s='source'


#which aws_completer
#export PATH="$(which aws_completer):${PATH}"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
#export FZF_COMPLETION_TRIGGER=''
#bindkey '^T' fzf-completion
#bindkey '^I' $fzf_default_completion


# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/hima/anaconda/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/hima/anaconda/etc/profile.d/conda.sh" ]; then
        . "/Users/hima/anaconda/etc/profile.d/conda.sh"
    else
        export PATH="/Users/hima/anaconda/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<


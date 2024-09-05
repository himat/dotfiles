# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

unsetopt autocd
unsetopt AUTO_CD

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
# export PATH="/usr/local/opt/python/libexec/bin:$PATH"

# Path to your oh-my-zsh installation.
export ZSH="/Users/$USER/.oh-my-zsh"

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
#   And I couldn't just source my entire ~/.shell_aliasrc file here because then
#   sourcing oh-my-zsh.sh alter overwrites some of the aliases like 'l'
#   So I just had to duplicate this single one here
# Saves current directory between sessions
unalias cd 2>/dev/null # Prevent infinite loops if sourcing this file again in the same session
logged_cd() {
    # return 1
    cd "$@" && pwd > ~/.last_cd || return 1
}

alias "cd"="logged_cd" # keep track of most recent directory 

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
# NOTE: zsh-syntax-highlighting needs to be the last plugin apparently (https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/INSTALL.md#with-a-plugin-manager)
# And fzf-tab should also be the last plugin that binds tab ("^I") (https://github.com/Aloxaf/fzf-tab#compatibility-with-other-plugins)
plugins=(git colorize autojump aws nvm poetry zsh-autosuggestions fzf-tab zsh-syntax-highlighting)

### fzf-tab settings
# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix -- not sure what this actually does, just recced config
zstyle ':completion:*' menu no
# preview directory's content with eza when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'

# use tmux popup feature to show fzf-tab window
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup

### /end fzf-tab settings

source $ZSH/oh-my-zsh.sh
#source $HOME/.bash_profile

######################### User configuration ==============================

# Don't make ohmyzsh correct all arguments too, but only correct commands
# This makes the corrections a lot less annoying but we do lose out on the 
# argument corrections which can be useful. Would prob be better at some point
# to just disable correction for my most used commands like git
unsetopt correctall
setopt correct


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
# Note: I was using these segment of commands before I added fzf-tab below
# (make sure to disable auto-completion import in ~/.fzf.zsh so that we can bind the tab-key here)
# bindkey '^I'      autosuggest-accept # C-I === tab key
# bindkey '^E'     forward-word
# bindkey '^[[Z' autosuggest-accept  # shift + tab  | autosuggest

# For use with fzf-tab
bindkey "^I" autosuggest-accept # Tab
bindkey "^[[Z" fzf-tab-complete # Shift-tab activates the fzf-tab window to search

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

#which aws_completer
#export PATH="$(which aws_completer):${PATH}"
export PATH="/usr/local/opt/ruby/bin:$PATH"
export PATH="$(gem env gemdir)/bin:$PATH"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
#export FZF_COMPLETION_TRIGGER=''
#bindkey '^T' fzf-completion
#bindkey '^I' $fzf_default_completion


function up_dir() {
    cd ..
    # Needed to refresh zsh prompt
    BUFFER=
    zle accept-line
}
zle -N up_dir up_dir
# alt-k to go cd up
bindkey "^[k" up_dir

export PATH="/usr/local/opt/openjdk/bin:$PATH"


test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"


# [mine] Load aliases and such
[ -f ~/.shell_aliasrc ] && source ~/.shell_aliasrc

# Load wezterm shell integration to enable things like awareness of shell command blocks to make the terminal smarter
[ -f ~/.wezterm_shell_integration.sh ] && . ~/.wezterm_shell_integration.sh


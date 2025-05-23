# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

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

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

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
alias priv="cd /home/darknet/CodingProjects/personal/generate-private-contributions && yarn start ~/CodingProjects/work 2025-01-01 2025-12-31 \"Krezeski\" /home/darknet/CodingProjects/personal/private-contributions && cd ../private-contributions && git status && git push"
#alias vpn="cd /home/darknet/CodingProjects/MAK-SYSTEM/vpn && sudo openvpn --config ./client.ovpn --auth-user-pass ./creds.txt"
#alias vpn2="cd /home/darknet/CodingProjects/MAK-SYSTEM/vpn && openvpn3 session-start --config ./ate.ovpn"
alias vpn="~/.local/scripts/connection.sh"
alias work="cd /home/darknet/CodingProjects/work"
alias personal="cd /home/darknet/CodingProjects/personal"
alias projects="cd /home/darknet/CodingProjects"
alias utils="nvim /home/darknet/CodingProjects/utils.txt"
alias vim="nvim"
alias mak="cd /home/darknet/CodingProjects/MAK-SYSTEM/europa/web"
alias g="git"

# AUTOCOMPLETION PLUGIN
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
bindkey '^ ' autosuggest-accept
bindkey '^w' vi-forward-word

# NVM
 export NVM_DIR=~/.nvm
 [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

# Android Studio Related Stuff
export PATH=~/Android/Sdk/platform:$PATH
export PATH=~/Android/Sdk/platform-tools:$PATH

if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# NodeJS Specific
node_version=$(node -v)
# Workaround for getting react work on Node 17+
if [[ "$node_version" == *"v18" ]]
then
    export NODE_OPTIONS=--openssl-legacy-provider
fi


# bit https://bit.dev/docs
# export PATH="$PATH:/home/darknet/bin"

export GOPATH="$HOME/go" # set GOPATH (path to where go is installed)
export PATH=$PATH:$GOPATH/bin # append GOPATH to PATH

# Lua Path
export LUAPATH="$HOME/lua-language-server"
export PATH=$PATH:LUAPATH/bin

# fzf for zsh
source <(fzf --zsh)
HISTFILE=~/.zsh_history
HISTSIZE=30000
setopt appendhistory

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/darknet/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
#if [ $? -eq 0 ]; then
#    eval "$__conda_setup"
#else
#    if [ -f "/home/darknet/anaconda3/etc/profile.d/conda.sh" ]; then
#        . "/home/darknet/anaconda3/etc/profile.d/conda.sh"
#    else
#        export PATH="/home/darknet/anaconda3/bin:$PATH"
#    fi
#fi
#unset __conda_setup
## <<< conda initialize <<<
##

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Nvim PATH
export PATH="$PATH:/opt/nvim-linux64/bin"

export TERM=xterm-256color
export BROWSER='/var/lib/flatpak/exports/share/applications/app.zen_browser.zen.desktop'

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/bin/terraform terraform

### SSH CONFIGURATION
sshf() {
  local IGNORE_WORDS=("github" "gitlab" "bitbucket")

  local host=$(awk '/^Host / && !/\*/ {print $2}' ~/.ssh/config \
    | while read -r h; do
        skip=false
        for word in "${IGNORE_WORDS[@]}"; do
          [[ "$h" == *"$word"* ]] && skip=true && break
        done
        $skip || echo "$h"
      done \
    | fzf --prompt="SSH > " --height=20 --border)

  [[ -n "$host" ]] && ssh "$host"
}


# CURSOR SHAPE
# Make sure this is same setting as in the terminal emulator configuration
# Block:
## - non-blinking: \e[2 q
## - blinking: \e[1 q

# Bar:
## - non-blinking: \e[6 q
## - blinking: \e[5 q
if [[ -n "$TMUX" ]]; then
  print -n '\e[5 q'
fi


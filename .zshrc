# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME="robbyrussell"
ZSH_THEME="gnzh"

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

source ~/source/zsh-z/zsh-z.plugin.zsh

autoload -U compinit && compinit
zstyle ':completion:*' menu select


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
# You can set one of the op tional three formats:
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


plugins=(git zaw docker ansible cp dotnet helm kubectl kubectx kube-ps1 pip python zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh
source ~/source/kube-ps1/kube-ps1.sh
PROMPT='$(kube_ps1)'$PROMPT

# zaw
source /home/lars/.oh-my-zsh/plugins/zaw/zaw.zsh
# CTRL-R will pull up zaw-history (backwards zsh history search)
bindkey '^r' zaw-history
bindkey -M filterselect '^E' accept-search
# CTRL-B will pull up zaw-git-branches which will search your current git branches and switch (git checkout) to the branch you select when you hit enter.
bindkey '^b' zaw-git-branches
zstyle ':filter-select:highlight' matched fg=green
zstyle ':filter-select' max-lines 6
zstyle ':filter-select' case-insensitive yes # enable case-insensitive
zstyle ':filter-select' extended-search yes # see below
zstyle ':filter-select' hist-find-no-dups yes # ignore duplicates in history source

command -v flux >/dev/null && . <(flux completion zsh)

backupvoron1() {
    echo "Fetching printer data from Voron1..."
    scp -r pi@voron1.local:~/printer_data ~/printer_data_backup

    if [ $? -eq 0 ]; then
        echo "Successfully retrieved printer data."
        echo "Copying data to NAS..."
        scp -P 22000 -r ~/printer_data_backup/ lars@nas.local:/volume1/Main/voron1backup/

        if [ $? -eq 0 ]; then
            echo "Backup successful! Cleaning up local backup folder..."
            rm -rf ~/printer_data_backup
            echo "Cleanup completed."
        else
            echo "Failed to copy data to NAS."
        fi
    else
        echo "Failed to fetch printer data from Voron1."
    fi
}



gitui-ssh() {
  key="${1:-$HOME/.ssh/id_rsa_06-2022}"
  eval "$(ssh-agent)" \
    && ssh-add "$key" \
    && command gitui "${@:2}" \
    && eval "$(ssh-agent -k)"
}

function vaultsetup() {
  if [ $# -ne 1 ]; then
    echo "Usage: VaultSetup <vault_url>"
    return 1
  fi

  export VAULT_ADDR="$1"

  # Prompt for the token without echoing input
  echo -n "Enter your Vault token: "
  read -s VAULT_TOKEN
  echo

  export VAULT_TOKEN

  echo "Vault CLI configured with VAULT_ADDR='$VAULT_ADDR'"
}

function ansiblesetup() {
  # Prompt for the become password
  echo -n "Enter your Ansible become password: "
  read -s ANSIBLE_BECOME_PASS
  echo

  # Export the password as an environment variable
  export ANSIBLE_BECOME_PASS

  # Prompt for the Vault password
  echo -n "Enter your Ansible Vault password: "
  read -s ANSIBLE_VAULT_PASSWORD
  echo

  # Write the Vault password to a temporary file
  echo "$ANSIBLE_VAULT_PASSWORD" > ~/.vault_pass.txt
  chmod 600 ~/.vault_pass.txt

  # Export the Vault password file path as an environment variable
  export ANSIBLE_VAULT_PASSWORD_FILE=~/.vault_pass.txt

  echo "Environment variables set."
}

# Function: dsh — Docker SH
# Usage: dsh <container-id-or-name>
# Example: dsh my-container

function dsh() {
    if [[ -z "$1" ]]; then
        echo "Usage: dsh <container-id-or-name>"
        return 1
    fi

    # Launches an interactive sh shell in the specified container
    docker exec -it "$1" sh
}

alias h=history
alias nas='ssh lars@nas.local -p 22000'
alias winhome='cd /mnt/d/source'
alias u1='ssh lars@ubuntusrv01.local'
alias u2='ssh lars@ubuntusrv02.local'
alias u3='ssh lars@ubuntusrv03.local'
alias u4='ssh lars@ubuntusrv04.local'
alias p1='ssh pi@printer01.local'
alias p2='ssh pi@printer02.local'
alias v1='ssh pi@voron1.local'
alias pihole1='ssh pi@pihole1.local'
alias pihole2='ssh pi@pihole2.local'

alias cat='batcat'
alias j='jrnl'
alias k='kubectl'
alias d='docker'
alias n='nerdctl'
alias kc='kubectx'
alias kn='kubens'

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias multipass='multipass.exe'

export PATH="$PATH:/mnt/c/Program Files/Oracle/VirtualBox"
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
export VAGRANT_WSL_ENABLE_WINDOWS_ACCESS="1"
export VAGRANT_DISABLE_STRICT_DEPENDENCY_ENFORCEMENT=1
export KUBECONFIG=$(find $HOME/.kube -type f \( -name "*.yaml" -o -name "*k3d*" -o -name "config" \) -print0 | tr '\0' ':')$HOME/.kube/config

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

#!/bin/sh

#WSL2 Ubuntu clean install with zsh and oh my zsh

sudo apt-get update && sudo apt-get full-upgrade -y
sudo apt install mc inetutils-tools fzf bat git -y

git config --global --add safe.directory '*'
git config --global user.name "Lars W. Andersen"
git config --global user.email "lars@factus.dk"

# docker service without docker desktop
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh ./get-docker.sh
sudo addgroup --system docker
sudo adduser $USER docker


# Eller bare brug podman  og set d som alias til podman som
# sudo apt install podman
# podman completion -f "${fpath[1]}/_podman" zsh

######  Brew  #################
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /home/lars/.zprofile
  sudo apt-get install build-essential
  brew install gcc

#zsh stuff
sudo apt install zsh -y
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
chsh -s $(which zsh)

# Setup syntax higlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
git clone git@github.com:zsh-users/zaw.git ~/.oh-my-zsh/plugins/zaw

mkdir ~/source
git clone git@github.com:agkozak/zsh-z.git ~/.oh-my-zsh/plugins/zsh-z
sudo git clone https://github.com/jonmosco/kube-ps1.git ~/source/kube-ps1

# AZ CLI
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
ln -s /etc/bash_completion.d/azure-cli ~/.oh-my-zsh/custom/az.zsh  #Auto completion

#KubeCtx
#KubeNs
sudo git clone https://github.com/ahmetb/kubectx /opt/kubectx
sudo ln -s /opt/kubectx/kubectx /usr/local/bin/kubectx
sudo ln -s /opt/kubectx/kubens /usr/local/bin/kubens

#Flux
brew install fluxcd/tap/flux

# Vault
sudo apt update && sudo apt install gpg wget
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
gpg --no-default-keyring --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg --fingerprint
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install vault


# Then change rights on the link
chmod go-r /mnt/c/Users/lars/.kube/config
chmod 700 /mnt/c/Users/Lars/.kube/config

#Github cli
type -p curl >/dev/null || (sudo apt update && sudo apt install curl -y)
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
&& sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
&& sudo apt update \
&& sudo apt install gh -y

# ACT run github actions locally

#DOTNET
declare repo_version=$(if command -v lsb_release &> /dev/null; then lsb_release -r -s; else grep -oP '(?<=^VERSION_ID=).+' /etc/os-release | tr -d '"'; fi)
wget https://packages.microsoft.com/config/ubuntu/$repo_version/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb
sudo apt update && sudo apt install -y dotnet-sdk-8.0


# Tools
brew tap weaveworks/tap
brew install weaveworks/tap/gitops
brew install derailed/popeye/popeye
brew install derailed/k9s/k9s
brew install act cloudflared  gitui  k9s kubernetes-cli libxcrypt openssl@3 skaffold trivy yq argocd gperf kind kustomize libyaml popeye talosctl  vagrant zlib ca-certificates  gitops k3d kubectx  libffi nvm ruby tilt yamlfmt
brew install ansible ansible-lint molecule jrnl

# KREW for kubectl
(
  set -x; cd "$(mktemp -d)" &&
  OS="$(uname | tr '[:upper:]' '[:lower:]')" &&
  ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" &&
  KREW="krew-${OS}_${ARCH}" &&
  curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz" &&
  tar zxvf "${KREW}.tar.gz" &&
  ./"${KREW}" install krew
)


# 1password
curl -sS https://downloads.1password.com/linux/keys/1password.asc | sudo gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg
echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/amd64 stable main' | sudo tee /etc/apt/sources.list.d/1password.list
sudo mkdir -p /etc/debsig/policies/AC2D62742012EA22/
curl -sS https://downloads.1password.com/linux/debian/debsig/1password.pol | sudo tee /etc/debsig/policies/AC2D62742012EA22/1password.pol
sudo mkdir -p /usr/share/debsig/keyrings/AC2D62742012EA22
curl -sS https://downloads.1password.com/linux/keys/1password.asc | sudo gpg --dearmor --output /usr/share/debsig/keyrings/AC2D62742012EA22/debsig.gpg
sudo apt update && sudo apt install 1password


curl -sS https://downloads.1password.com/linux/keys/1password.asc | \
  sudo gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg && \
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/$(dpkg --print-architecture) stable main" | \
  sudo tee /etc/apt/sources.list.d/1password.list && \
  sudo mkdir -p /etc/debsig/policies/AC2D62742012EA22/ && \
  curl -sS https://downloads.1password.com/linux/debian/debsig/1password.pol | \
  sudo tee /etc/debsig/policies/AC2D62742012EA22/1password.pol && \
  sudo mkdir -p /usr/share/debsig/keyrings/AC2D62742012EA22 && \
  curl -sS https://downloads.1password.com/linux/keys/1password.asc | \
  sudo gpg --dearmor --output /usr/share/debsig/keyrings/AC2D62742012EA22/debsig.gpg && \
  sudo apt update && sudo apt install 1password-cli

# CopyQ
sudo apt install software-properties-common python-software-properties
sudo add-apt-repository ppa:hluk/copyq
sudo apt update
sudo apt install copyq


# Rancher Desktop
curl -s https://download.opensuse.org/repositories/isv:/Rancher:/stable/deb/Release.key | gpg --dearmor | sudo dd status=none of=/usr/share/keyrings/isv-rancher-stable-archive-keyring.gpg
echo 'deb [signed-by=/usr/share/keyrings/isv-rancher-stable-archive-keyring.gpg] https://download.opensuse.org/repositories/isv:/Rancher:/stable/deb/ ./' | sudo dd status=none of=/etc/apt/sources.list.d/isv-rancher-stable.list
sudo apt update
sudo apt install rancher-desktop

# VS Code
sudo apt-get install wget gpg
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" |sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null
rm -f packages.microsoft.gpg
sudo apt install apt-transport-https
sudo apt update
sudo apt install code # or code-insiders



# Synology drive client

# Define variables
SYN_URL="https://global.download.synology.com/download/Utility/SynologyDriveClient/3.5.0-15937/Ubuntu/Installer/x86_64/synology-drive-client-3.5.0-15937.x86_64.deb"
TEMP_DEB="/tmp/synology-drive-client.deb"

# Update system
echo "Updating package lists..."
sudo apt update -y && sudo apt upgrade -y

# Install dependencies
echo "Installing required dependencies..."
sudo apt install -y libqt5gui5 libqt5network5 libqt5core5a qtbase5-dev

# Download Synology Drive Client
echo "Downloading Synology Drive Client..."
wget -O "$TEMP_DEB" "$SYN_URL"

# Install Synology Drive Client
echo "Installing Synology Drive Client..."
sudo dpkg -i "$TEMP_DEB"

# Fix missing dependencies
echo "Fixing dependencies..."
sudo apt install -f -y

# Cleanup
echo "Cleaning up..."
rm "$TEMP_DEB"

# Done
echo "Installation complete. You can now launch Synology Drive Client from the application menu."

# Multipass
sudo snap install multipass
sudo snap install firmware-updater
sudo snap install signal-desktop
sudo snap install firefox
sudo snap install drawio

sudo apt install pipx

#Python3 and pip3
sudo apt install python3-pip

#jrnl
# /mnt/d/Documents/jrnl/journal.txt
# nano edit ca  og angiv nano som editor   eller code med "code --wait"

#Used for ansible
sudo apt install -y sshpass

# To make ssh ans ansible resolve servers by name update
# /etc/nsswitch.conf and add dns before mdns4_minimal [NOTFOUND=return]
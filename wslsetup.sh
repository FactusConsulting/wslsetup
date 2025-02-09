#!/bin/sh

#WSL2 Ubuntu clean install with zsh and oh my zsh

sudo apt-get update && sudo apt-get full-upgrade -y
sudo apt install mc inetutils-tools fzf bat -y

## Maybe 1password cli

#To use rancher-desktop with wsl docker (not needed for nerdctl and containerd)
# Install docker locally so you use rancher-desktop from windows
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh ./get-docker.sh
sudo addgroup --system docker
sudo adduser $USER docker




#Eller bare brug podman  og set d som alias til podman som
#sudo apt install podman
# podman completion -f "${fpath[1]}/_podman" zsh

# Maybe using rancher-desktop docker instances?  This is for when using containerd
# And something needs to be done so $USER always runs in group `docker` on the `Ubuntu` WSL
# sudo chown root:docker /var/run/docker.sock   #Is this still needed when running rancher-desktop?
# sudo chmod g+w /var/run/docker.sock

######  Brew  #################
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /home/lars/.zprofile
sudo apt-get install build-essential
brew install gcc

#zsh stuff
sudo apt install zsh -y
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Setup syntax higlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
git clone git@github.com:zsh-users/zaw.git ~/.oh-my-zsh/plugins/zaw


mkdir ~/source
cd ~/source
git clone git@github.com:agkozak/zsh-z.git ~/source/zsh-z
git clone git@ssh.dev.azure.com:v3/Factus/Main/ansible ~/source/ansible
# Get kubernetes context on cmd line
sudo git clone https://github.com/jonmosco/kube-ps1.git ~/source/kube-ps1

# AZ CLI
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
ln -s /etc/bash_completion.d/azure-cli ~/.oh-my-zsh/custom/az.zsh  #Auto completion

#Python3 and pip3
sudo apt install python3-pip
pip3 install --upgrade ansible ansible-lint molecule

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

git config --global --add safe.directory '*'
git config --global user.name "Lars W. Andersen"
git config --global user.email "lars@factus.dk"


# pipx
python3 -m pip install --user pipx
python3 -m pipx ensurepath
sudo apt install python3.10-venv

#jrnl
pipx install jrnl
# /mnt/d/Documents/jrnl/journal.txt
# nano edit ca  og angiv nano som editor   eller code med "code --wait"


####  To solve errors around unsecure kubeconfigs
# On WSL Linux create a etc/wsl.conf   Then wsl --terminate ubuntu and wait 8 seconds

sudo cp wsl.conf /etc/

# Then change rights on the link
chmod go-r /mnt/c/Users/lars/.kube/config
chmod 700 /mnt/c/Users/Lars/.kube/config


#Kubectl locally
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://dl.k8s.io/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update -y
sudo apt-get install -y kubectl



#Github cli
type -p curl >/dev/null || (sudo apt update && sudo apt install curl -y)
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
&& sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
&& sudo apt update \
&& sudo apt install gh -y

# ACT run github actions locally
brew install act

#Other stuff
brew install derailed/k9s/k9s

brew tap weaveworks/tap
brew install weaveworks/tap/gitops

brew install derailed/popeye/popeye
## Mangler
###  Mangler der maaske noget mere command completion scriptet her?


#DOTNET
declare repo_version=$(if command -v lsb_release &> /dev/null; then lsb_release -r -s; else grep -oP '(?<=^VERSION_ID=).+' /etc/os-release | tr -d '"'; fi)
wget https://packages.microsoft.com/config/ubuntu/$repo_version/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb
sudo apt update && sudo apt install -y dotnet-sdk-8.0


brew install act cloudflared  gitui  k9s kubernetes-cli libxcrypt openssl@3 skaffold trivy yq argocd flux gperf kind kustomize libyaml popeye talosctl  vagrant zlib ca-certificates  gitops k3d kubectx  libffi nvm ruby tilt yamlfmt

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

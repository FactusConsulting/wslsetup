#!/bin/sh

#WSL2 Ubuntu clean install with zsh and oh my zsh

sudo apt-get update && sudo apt-get full-upgrade -y
sudo apt install mc inetutils-tools fzf bat -y

## Maybe 1password cli

#To use rancher-desktop with wsl docker (not needed for nerdctl and containerd)
Install docker locally so you use rancher-desktop from windows
sudo sh ./get-docker.sh
sudo addgroup --system docker
sudo adduser $USER docker

# Maybe using rancher-desktop docker instances?  This is for when using containerd
# And something needs to be done so $USER always runs in group `docker` on the `Ubuntu` WSL
# sudo chown root:docker /var/run/docker.sock   #Is this still needed when running rancher-desktop?
# sudo chmod g+w /var/run/docker.sock

#zsh stuff
sudo apt install zsh -y
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Setup syntax higlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting

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
curl -s https://fluxcd.io/install.sh | sudo bash

git config --global --add safe.directory '*'
git config --global user.name "Lars W. Andersen"
git config --global user.email "lars@factus.dk"

curl -sS https://webinstall.dev/k9s | bash

# pipx
python3 -m pip install --user pipx
python3 -m pipx ensurepath
sudo apt install python3.8-venv

#jrnl
pipx install jrnl
# /mnt/d/Documents/jrnl/journal.txt
# nano edit ~/.config/jrnl/jrnl.yaml  og angiv nano som editor


####  To solve errors around unsecure kubeconfigs
# On WSL Linux create a etc/wsl.conf   Then wsl --terminate ubuntu and wait 8 seconds

sudo cp wsl.conf /etc/

# Then change rights on the link
chmod go-r /mnt/c/Users/lars/.kube/config
chmod 700 /mnt/c/Users/Lars/.kube/config


#Kubectl locally
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubectl

######  Brew  #################
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /home/lars/.zprofile
sudo apt-get install build-essential
brew install gcc


#Github cli
type -p curl >/dev/null || (sudo apt update && sudo apt install curl -y)
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
&& sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
&& sudo apt update \
&& sudo apt install gh -y

# ACT run github actions locally
brew install act

## Mangler
###  Mangler der maaske noget mere command completion scriptet her?
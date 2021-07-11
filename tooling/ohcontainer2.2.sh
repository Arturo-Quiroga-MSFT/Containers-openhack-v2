#
# Ubuntu/Debian
# Install Azure CLI
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# Install Docker
sudo snap install docker

# sudo apt-get update
# sudo apt-get install -y apt-transport-https ca-certificates curl
# sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
# echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

# curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -
# echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list

# sudo apt-get update
# sudo apt-get -y --fix-broken install
# sudo apt-get update

sudo snap install kubectl --classic
sudo snap install helm --classic

# sudo apt-get install -y kubectl
# sudo apt-get install -y helm

sudo apt -y autoremove


#!/bin/bash


# sudo swapoff -a 
# vim /etc/fstab et commenter "swap...."

# prerequis installation gestionnanire de container a faire sur tout les noeuds
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.ipv4.ip_forward = 1
EOF

### Apply sysctl params without reboot
sudo sysctl --system
### Verify that net.ipv4.ip_forward is set to 1 with:
sysctl net.ipv4.ip_forward

### CRI-O Install instructions
KUBERNETES_VERSION=v1.32
CRIO_VERSION=v1.32

apt-get update
apt-get install -y software-properties-common curl

curl -fsSL https://download.opensuse.org/repositories/isv:/cri-o:/stable:/$CRIO_VERSION/deb/Release.key |
    gpg --dearmor -o /etc/apt/keyrings/cri-o-apt-keyring.gpg
echo "deb [signed-by=/etc/apt/keyrings/cri-o-apt-keyring.gpg] https://download.opensuse.org/repositories/isv:/cri-o:/stable:/$CRIO_VERSION/deb/ /" |
    tee /etc/apt/sources.list.d/cri-o.list

apt-get update
apt-get install -y cri-o

systemctl start crio.service   

modprobe br_netfilter
echo br_netfilter >> /etc/modules-load.d/crio.conf
modprobe br_netfilter


# Installing kubeadm, kubelet and kubectl (tout les noeuds)
sudo apt-get update
### apt-transport-https may be a dummy package; if so, you can skip that package
sudo apt-get install -y apt-transport-https ca-certificates curl gpg

curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.32/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.32/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

sudo systemctl enable --now kubelet

# Activation autocompletion
source <(kubectl completion bash) 
echo "source <(kubectl completion bash)" >> ~/.bashrc 
alias k=kubectl
complete -o default -F __start_kubectl k
source ~/.bashrc
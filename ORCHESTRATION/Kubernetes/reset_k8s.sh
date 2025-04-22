#!/bin/bash


```bash
# Commande a taper sur un noeud pour le renitialiser
sudo kubeadm reset -f
sudo systemctl stop kubelet
sudo systemctl stop docker

sudo rm -rf /etc/cni/net.d
sudo rm -rf /var/lib/cni/
sudo rm -rf /var/lib/kubelet/*
sudo rm -rf /etc/kubernetes/

sudo systemctl start docker
sudo systemctl start kubelet
```
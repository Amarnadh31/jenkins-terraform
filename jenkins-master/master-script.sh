#!/bin/bash


lsblk
sudo pvcreate /dev/xvdb
sudo vgextend RootVG /dev/xvdb
sudo lvextend -L +25G /dev/RootVG/homeVol
sudo lvextend -L +24G /dev/RootVG/rootVol
sudo xfs_growfs /dev/RootVG/homeVol
sudo xfs_growfs /dev/RootVG/rootVol


sudo curl -o /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
sudo yum upgrade -y
# Add required dependencies for the jenkins package
sudo yum install fontconfig java-17-openjdk -y
sudo yum install jenkins -y
sudo systemctl daemon-reload
sudo systemctl enable jenkins
sudo systemctl start jenkins
sudo systemctl status jenkins





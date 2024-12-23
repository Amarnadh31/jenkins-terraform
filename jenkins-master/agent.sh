#!/bin/bash


lsblk
sudo pvcreate /dev/xvdb
sudo vgextend RootVG /dev/xvdb
sudo lvextend -L +25G /dev/RootVG/homeVol
sudo lvextend -L +24G /dev/RootVG/rootVol
sudo xfs_growfs /dev/RootVG/homeVol
sudo xfs_growfs /dev/RootVG/rootVol

# Add required dependencies for the jenkins package
sudo yum install fontconfig java-17-openjdk -y
yum install -y yum-utils
yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
yum -y install terraform
dnf module disable nodejs -y
dnf module enable nodejs:20 -y
dnf install nodejs -y
yum install zip -y

# docker
yum install -y yum-utils
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
systemctl start docker
systemctl enable docker
usermod -aG docker ec2-user

#helm

curl -fsSL https://get.helm.sh/helm-v3.16.3-linux-amd64.tar.gz -o helm-v3.16.3-linux-amd64.tar.gz
tar -zxvf helm-v3.16.3-linux-amd64.tar.gz
mv linux-amd64/helm /usr/local/bin/helm
chmod +x /usr/local/bin/helm
echo 'Helm installation complete!'
export PATH=$PATH:/usr/local/bin  # Ensure /usr/local/bin is in the PATH
helm version  # Verify Helm is installed successfully
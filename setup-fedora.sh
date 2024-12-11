#!/bin/bash

# Update system
dnf update -y
echo "max_parallel_downloads=10" >> /etc/dnf/dnf.conf
echo "fastestmirror=True" >> /etc/dnf/dnf.conf

# Enable RPM Fusion
dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
dnf install -y https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
dnf upgrade --refresh -y
dnf groupupdate core -y

# Install docker
dnf remove -y docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-selinux \
                  docker-engine-selinux \
                  docker-engine

dnf -y install dnf-plugins-core
dnf-3 config-manager -y --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
systemctl start docker
systemctl enable docker

# Install terraform
dnf install -y dnf-plugins-core
dnf-3 config-manager -y --add-repo https://rpm.releases.hashicorp.com/fedora/hashicorp.repo
dnf -y install terraform

# Install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Install aws cli
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install

################## THIS IS NOT WORKING YET!!! ##################
# # Install virtualbox-7
# dnf upgrade --refresh
# dnf install @development-tools -y 
# dnf install kernel-devel kernel-headers dkms qt5-qtx11extras elfutils-libelf-devel zlib-devel -y
# wget http://download.virtualbox.org/virtualbox/rpm/fedora/virtualbox.repo -P /etc/yum.repos.d/
# dnf install VirtualBox-7.0 -y 
# systemctl enable vboxdrv --now
#################################################################

# Install ansible
dnf install -y python3-pip
python3 -m pip install --user ansible

# Install discord
dnf upgrade -y --refresh
dnf install -y discord

# Install lens k8s
dnf config-manager -y --add-repo https://downloads.k8slens.dev/rpm/lens.repo
dnf -y install lens

# Install teamviewer
wget https://download.teamviewer.com/download/linux/teamviewer.x86_64.rpm -O teamviewer.rpm
dnf install -y teamviewer.rpm

# Install visual studio code
rpm --import https://packages.microsoft.com/keys/microsoft.asc
sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
dnf check-update -y
dnf install -y code

# Codecs
dnf install gstreamer1-plugins-{bad-\*,good-\*,base} gstreamer1-plugin-openh264 gstreamer1-plugin-libav --exclude=gstreamer1-plugins-bad-free-devel -y
dnf install lame\* --exclude=lame-devel -y
dnf group upgrade --with-optional Multimedia

# Tilix
dnf install -y tilix

#!/bin/bash

set -e

# if set will not create store history
set +o history

# Apply the latest security patches for Ubuntu
sudo -s -- <<EOF
	export DEBIAN_FRONTEND=noninteractive
	apt-get update
	apt-get autoremove -y
	apt-get update
	apt-get upgrade -y

echo "Security Updates Applied!.."

	apt-get update
	unattended-upgrade

echo "apt-get update done!.."

# This is default software for all AWS Builds

	apt-get install -y awscli
	apt-get install -y python-pip python3-pip maven

	apt-get update
	apt-get install -y openjdk-8-jdk
	apt-get update
	apt-get install unzip
EOF

echo "ssh-rsa <your ssh rsa key goes here> user@ip-address" >> ~/.ssh/authorized_keys

#######################
# Install Packer 
#######################

PACKER_VER="1.4.4"
wget https://releases.hashicorp.com/packer/${PACKER_VER}/packer_${PACKER_VER}_linux_amd64.zip
unzip packer_${PACKER_VER}_linux_amd64.zip

#######################
# Install Terraform 
#######################

TERRAFORM_VER="0.12.12"
wget https://releases.hashicorp.com/terraform/${TERRAFORM_VER}/terraform_${TERRAFORM_VER}_linux_amd64.zip
unzip terraform_${TERRAFORM_VER}_linux_amd64.zip

sudo -s -- <<EOF
		
	mv packer /usr/local/bin
	rm packer_${PACKER_VER}_linux_amd64.zip

	mv terraform /usr/local/bin
	rm terraform_${TERRAFORM_VER}_linux_amd64.zip

	export DEBIAN_FRONTEND=noninteractive
	apt-add-repository --yes --update ppa:ansible/ansible
	apt-get update
	apt-get install -y ansible

	apt-get update
	apt-get install -y apt-transport-https
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - 2> /dev/null
	add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
	apt-get update
	apt-cache policy docker-ce
	apt-get install -y docker-ce

	curl -L https://github.com/docker/compose/releases/download/1.25.0-rc2/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
	chmod +x /usr/local/bin/docker-compose

	apt-get update
	apt-get install -y jq

	ufw allow ssh
	echo "y" | ufw enable

EOF
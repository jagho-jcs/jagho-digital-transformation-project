#!/bin/bash

set -e

# if set will not create store history
set +o history

# Apply the latest security patches for the instance
sudo -s -- <<EOF
apt-get update
DEBIAN_FRONTEND=noninteractive apt-get autoremove -y
apt-get update
DEBIAN_FRONTEND=noninteractive apt-get upgrade -y
echo "Security Updates Applied!.."
apt-get update
unattended-upgrade
echo "apt-get update done!.."
apt-get update
DEBIAN_FRONTEND=noninteractive apt-get install -y python-pip python3-pip
EOF
# Will upgrade pip to the latest version
sudo -s -H DEBIAN_FRONTEND=noninteractive pip install --upgrade pip

# Will install awscli and default jdk 

sudo -s -- <<EOF
DEBIAN_FRONTEND=noninteractive apt-get install -y awscli openjdk-8-jdk

apt-get update

# This will add the repository key to the system

	wget -q -O - https://pkg.jenkins.io/debian/jenkins-ci.org.key | sudo apt-key add - 

# This will append the Debian package repository address to the server's source list

	echo deb https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list

# Run apt-get to use the repository

	apt-get update

# This will install the latest version of jenkins

# http://pkg.jenkins-ci.org/debian-stable/binary/jenkins_2.204.5_all.deb

# This will install Jenkins 2.204.5

	apt-get install -y jenkins=2.204.5

	systemctl stop jenkins

	mkdir -p /mnt/JENKINS_HOME

	chown -R jenkins:jenkins /mnt/JENKINS_HOME

	apt-get update

	apt-get install -y nfs-common

	mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport fs-547ddfe5.efs.eu-west-3.amazonaws.com:/ /mnt/JENKINS_HOME

	echo "fs-547ddfe5.efs.eu-west-3.amazonaws.com:/ /mnt/JENKINS_HOME nfs defaults,vers=4.1 0 0" | sudo tee -a /etc/fstab

	sed -i -e 's|JENKINS_HOME=.*|JENKINS_HOME=/mnt/JENKINS_HOME/$NAME|g' /etc/default/jenkins

	rm -rf /var/lib/jenkins/

	ufw allow ssh
	
	ufw allow 8080
	
	echo "y" | ufw enable

EOF

ssh-keygen -t rsa -N "" -f /home/ubuntu/.ssh/id_rsa
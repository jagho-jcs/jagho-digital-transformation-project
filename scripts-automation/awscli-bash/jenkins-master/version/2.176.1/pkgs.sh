#!/bin/bash

set -e

# if set will not create store history
set +o history

sudo -s -- <<EOF

export DEBIAN_FRONTEND=noninteractive

apt-get update

apt-get install -y openjdk-8-jdk

apt-get update

# This will add the repository key to the system

	wget -q -O - https://pkg.jenkins.io/debian/jenkins-ci.org.key | sudo apt-key add - 

# This will append the Debian package repository address to the server's source list

	echo deb https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list

# Run apt-get to use the repository

	apt-get update

# This will install the latest version of jenkins

# http://pkg.jenkins-ci.org/debian-stable/binary/jenkins_2.190.2_all.deb

# This will install Jenkins 2.176.1 

	apt-get install -y jenkins=2.190.2

	systemctl stop jenkins

	mkdir -p /mnt/JENKINS_HOME

	chown jenkins:jenkins /mnt/JENKINS_HOME

	apt-get update

	apt-get install -y nfs-common

	mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport fs-997e7951.efs.eu-west-1.amazonaws.com:/ /mnt/JENKINS_HOME

	echo "fs-997e7951.efs.eu-west-1.amazonaws.com:/ /mnt/JENKINS_HOME nfs defaults,vers=4.1 0 0" | sudo tee -a /etc/fstab

	rm -rf /var/lib/jenkins/

	sed -i -e 's|JENKINS_HOME=.*|JENKINS_HOME=/mnt/JENKINS_HOME/jenkins/$NAME|g' /etc/default/jenkins

	ufw allow ssh
	
	ufw allow 8080
	
	echo "y" | ufw enable
EOF
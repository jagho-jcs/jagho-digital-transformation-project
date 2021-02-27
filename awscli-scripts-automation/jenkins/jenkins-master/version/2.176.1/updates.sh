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
DEBIAN_FRONTEND=noninteractive apt-get install -y python-pip \
	python3-pip
EOF
# Will upgrade pip to the latest version
sudo -s -H DEBIAN_FRONTEND=noninteractive pip install --upgrade pip

# Will install awscli and default jdk 
sudo -s -- <<EOF
DEBIAN_FRONTEND=noninteractive apt-get install -y awscli \
	openjdk-8-jdk
EOF
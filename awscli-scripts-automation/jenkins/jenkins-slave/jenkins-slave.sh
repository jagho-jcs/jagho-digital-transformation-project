#!/bin/bash

# MIT Licence applies, except if you modify this script you agree to the following terms:
# Don't use `set -e`, you're not an animal. Trap your errors.
# Don't use uppercase for variables that aren't inherited from the environment.
# Use 'echo -e' by default because science.
# Terminate lines with semicolons because voodoo.
# Quote your variable interpolations just about everywhere.

# Usage: ./deploy-jenkins-slave.sh <build option>

# Standardised error process. Errors to STDERR.
function error_and_die() {
  echo -e "[ERROR] ${1}" >&2;
  exit 1;
}

function myerror() {
	echo -e "[ERROR] ${1}" >&2;
}

declare deregister_image;
declare build_option="${1}";

# Get Public IP
my_ip="$(curl -s https://api.ipify.org || echo "Failed")";
[ "${my_ip}" == "Failed" ] \
  && error_and_die "Failed to retrieve your IP from api.ipify.org.
Please check your internet connection!!!";

# cidr block
my_cidr="${my_ip}/32";

# ...
ami_file="my_ami";
snapshot_file="my_snapshot";
# launch_config_file="my_launch_config";
# auto_scaling_grp_file="my_auto_scaling_grp";

#########################################################################################
#																						#
#																						#
# 	DO NOT MAKE ANY CHANGES ABOVE..														#
#																						#
#																						#
#########################################################################################

# ...
aws_default_profile="dev-jcs";

# ...
network_acl_id="acl-0df16bbe0208bbfc9";
grp_id="sg-0eb8f99da104835bc";
rule_number=120;
port_range_from=22;
port_range_to=22;
# block_device_mappings=`"[{\"DeviceName\": \"/dev/sda1\",\"Ebs\":{\"VolumeSize\":10}}]"`;
# user_data="file://usrdata_jenkins_slave.txt";

# ...
# key_name="jcs_demo_ireland";
# security_grps="sg-0400d0afa095f2360";
# instance_type="t2.micro";
# instance_monitoring="Enabled=false";

# ...



# ...
artifacts_file="slave_build_artifacts";
packer_bld_file="jenkins-slave";

#########################################################################################
#																						#
#																						#
# 	DO NOT MAKE ANY CHANGES BELOW..														#
#																						#
#																						#
#########################################################################################

# ...
my_ami="$(cat my_ami.txt)";
my_snapshot="$(cat my_snapshot.txt)";

export AWS_DEFAULT_PROFILE=${aws_default_profile};

if [[ "${build_option}" == "" ]]; then
	echo -en "Please enter a build option.  Thank you.  i.e [ build ]\n";
fi

if [[ "${build_option}" == "build" ]]; then
	echo -en "Deploying ami: ${packer_bld_file}...\n";

# ... Deletes the existing network acl entry
	echo -en "Deleting existing network acl entry: ${network_acl_id} ...";
	aws ec2 delete-network-acl-entry \
		--network-acl-id ${network_acl_id} \
		--ingress --rule-number ${rule_number} \
		&& echo -e "Successfull" \
		|| echo -e "Failed\nInformation Only!..\nWill now create  network entry in ${network_acl_id}";

# ... Creates a network acl entry with my Public IP
	echo -en "Creating new network acl entry: ${network_acl_id} ... ";
	aws ec2 create-network-acl-entry \
		--network-acl-id ${network_acl_id} \
		--ingress --rule-number $rule_number \
		--protocol tcp \
		--port-range From=${port_range_from},To=${port_range_to} \
		--cidr-block ${my_cidr} \
		--rule-action allow \
		&& echo -e "Successfull" \
		|| echo -e "Failed";
# ...
	echo -en "Deregistering ami: ${my_ami}... ";
	deregister_image="$(aws ec2 deregister-image \
		--image-id ${my_ami} \
		|| echo "Failed")";

	if [[ "${deregister_image}" == "Failed" ]]; then
		echo -en "Failed\nPlease remember to remove snap-shot from console.  Thank you!..\n";
		else
			echo -en "Successfull\nDeleting snapshot: ${my_snapshot}...";
				aws ec2 delete-snapshot \
				--snapshot-id ${my_snapshot} \
				&& echo -e "Successfull" \
				|| echo -e "Failed"; # Non-fatal..	
	fi
# ...
	echo -en "Building new ami: ${packer_bld_file}...\n"
	packer build -machine-readable ${packer_bld_file}.json | tee ${artifacts_file}.txt \
		&& echo -e "Successfull" \
		|| echo -e "Failed";

	echo -en "Writing image-id to file...";
	sed -n 's/.*AMI: //p' ${artifacts_file}.txt > ${ami_file}.txt \
		&& echo -e "Done" || echo -e "Failed\nIf not found the file will be created!..";

	echo -en "Writing snapshot-id to file...";
	sed -n 's/.*Tagging snapshot: //p' ${artifacts_file}.txt > ${snapshot_file}.txt \
			&& echo -e "Done" || echo -e "Failed\nIf not found the file will be created!..";

	my_new_ami="$(cat my_ami.txt)";
	my_new_snapshot="$(cat my_snapshot.txt)";
	
	echo -en "Successfully written new image-id: ${my_new_ami} to file...\n";
	echo -en "Successfully written snapshot-id: ${my_new_snapshot} to file...\n";
fi

# ...
if [[ "${build_option}" == "delete" ]]; then
	echo -en "Deregistering ${my_ami}... ";
	deregister_image="$(aws ec2 deregister-image \
		--image-id ${my_ami} \
		|| echo "Failed")";

	if [[ "${deregister_image}" == "Failed" ]]; then
		echo -en "Failed\nPlease remember you might need to remove snap-shot from console.  Thank you!..\n";
		else
			echo -en "Successfull\nDeleting snapshot ${my_snapshot}...";
			aws ec2 delete-snapshot \
				--snapshot-id ${my_snapshot} \
				&& echo -e "Successfull" \
				|| echo -e "Failed"; # Non-fatal..	
	fi
fi

# No errors
exit 0;
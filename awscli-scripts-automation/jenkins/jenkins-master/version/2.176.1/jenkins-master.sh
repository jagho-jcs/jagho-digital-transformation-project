#!/bin/bash

# MIT Licence applies, except if you modify this script you agree to the following terms:
# Don't use `set -e`, you're not an animal. Trap your errors.
# Don't use uppercase for variables that aren't inherited from the environment.
# Use 'echo -e' by default because science.
# Terminate lines with semicolons because voodoo.
# Quote your variable interpolations just about everywhere.

# Usage: ./deploy-jenkins-master.sh <build option>

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
launch_config_file="my_launch_config";
auto_scaling_grp_file="my_auto_scaling_grp";

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
user_data="file://my_usrdata.txt";

# ...
key_name="jcs_demo_ireland";
security_grps="sg-00eca0b3f30287d16";
instance_type="t2.micro";
instance_monitoring="Enabled=false";

# ...



# ...
artifacts_file="jenkins_master_build_artifacts";
packer_bld_file="jenkins-master";

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


	echo -en "Writing launch configuration to file...";
	sed -n 's/.*"launch_config_name": //p' ${artifacts_file}.txt | tr -d '"' > ${launch_config_file}.txt \
			&& echo -e "Done" || echo -e "Failed\nIf not found the file will be created!..";

	my_launch_config="$(cat my_launch_config.txt)";

	echo -en "Successfully written launch configuration: ${my_launch_config} to file...\n";
	
	echo -en "Creating launch configuration: ${my_launch_config}...";
	aws autoscaling create-launch-configuration \
		--launch-configuration-name ${my_launch_config} \
		--key-name ${key_name} \
		--security-groups ${security_grps} \
		--image-id ${my_new_ami} \
		--instance-type ${instance_type} \
		--associate-public-ip-address \
		--instance-monitoring ${instance_monitoring} \
		--block-device-mappings "[{\"DeviceName\": \"/dev/sda1\",\"Ebs\":{\"VolumeSize\":10}}]" \
		--user-data ${user_data} \
			&& echo -e "Successfull" \
			|| echo -e "Failed"; # Non-fatal..

	echo -en "Writing autoscaling group name to file...";
	sed -n 's/.*"auto_scaling_grp_name": //p' ${artifacts_file}.txt | tr -d '"' > ${auto_scaling_grp_file}.txt \
			&& echo -e "Done" || echo -e "Failed\nIf not found the file will be created!..";
	
	my_auto_scaling_grp="$(cat my_auto_scaling_grp.txt)";
	
	echo -en "Successfully written autoscaling group: ${my_auto_scaling_grp} to file...\n";

# ...
	echo -en "Creating Autoscaling group and applying cron jobs for scheduled actions..!\nPlease wait...\n"
	./ec2-jenkins-master-admin.sh \
			&& echo -e "Successfull\nPlease attach target group to ${my_auto_scaling_grp}\nThank you!.." \
			|| echo -e "Failed"; # Non-fatal..
fi

# No errors
exit 0;
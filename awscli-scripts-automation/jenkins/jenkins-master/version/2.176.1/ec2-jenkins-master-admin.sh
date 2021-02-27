#!/bin/bash

# MIT Licence applies, except if you modify this script you agree to the following terms:
# Don't use `set -e`, you're not an animal. Trap your errors.
# Don't use uppercase for variables that aren't inherited from the environment.
# Use 'echo -e' by default because science.
# Terminate lines with semicolons because voodoo.
# Quote your variable interpolations just about everywhere.

# Usage: ./ec2-jenkins-jenkins-master.sh <build option>

# Standardised error process. Errors to STDERR.
function error_and_die() {
  echo -e "[ERROR] ${1}" >&2;
  exit 1;
}

#########################################################################################
#																						#
#																						#
# 	Local variables these can be changed below..										#
#																						#
#																						#
#########################################################################################

# ...
app_name="jenkins-master";
role="Master";
ProvisionedWith="awscli"
jenkins_master_asg="$(cat my_auto_scaling_grp.txt)";
launch_configuration_name="$(cat my_launch_config.txt)";
vpc_zone_identifier="subnet-your-aws-subnet,
					 subnet-your-aws-subnet,
					 subnet-your-aws-subnet";
aws_default_profile="your-aws-profile";

#########################################################################################
#																						#
#																						#
# 	Do not make any changes below..														#
#																						#
#																						#
#########################################################################################

# ...
export AWS_DEFAULT_PROFILE="${aws_default_profile}"

echo -en "Creating autoscaling group: ${jenkins_master_asg}..\n"
aws autoscaling create-auto-scaling-group \
	--auto-scaling-group-name "${jenkins_master_asg}" \
	--launch-configuration-name "${launch_configuration_name}" \
	--min-size 0 --max-size 0 --desired-capacity 0 \
	--vpc-zone-identifier "${vpc_zone_identifier}" \
		&& echo -e "Successfull" \
		|| echo -e "Failed"; # Non-fatal..

echo -en "Applying schedule out of office hours... ";
aws autoscaling put-scheduled-update-group-action \
	--auto-scaling-group-name "${jenkins_master_asg}" \
	--scheduled-action-name out-of-office-hours \
	--recurrence "0 19 * * MON-FRI" \
	--min-size 0 --max-size 0 --desired-capacity 0 \
		&& echo -e "Successfull" \
		|| echo -e "Failed"; # Non fatal.. Information only

echo -en "Applying schedule office hours... ";
aws autoscaling put-scheduled-update-group-action \
	--auto-scaling-group-name "${jenkins_master_asg}" \
	--scheduled-action-name office-hours \
	--recurrence "0 9 * * MON-FRI" \
	--min-size 0 --max-size 0 --desired-capacity 0 \
		&& echo -e "Successfull" \
		|| echo -e "Failed"; # Non fatal.. Information only

echo -en "Applying tags to Autoscaling group...";
aws autoscaling create-or-update-tags --tags \
ResourceId="${jenkins_master_asg}",\
ResourceType=auto-scaling-group,\
Key=Name,Value=${app_name},\
PropagateAtLaunch=true \
ResourceId="${jenkins_master_asg}",\
ResourceType=auto-scaling-group,\
Key=ProvisionedWith,Value=${ProvisionedWith},\
PropagateAtLaunch=true \
ResourceId=${jenkins_master_asg},\
ResourceType=auto-scaling-group,\
Key=ProvisionedBy,Value="Yomi Ogunyinka",\
PropagateAtLaunch=true \
ResourceId=${jenkins_master_asg},\
ResourceType=auto-scaling-group,\
Key=Role,Value="${role}",\
PropagateAtLaunch=true \
ResourceId=${jenkins_master_asg},\
ResourceType=auto-scaling-group,\
Key=Environment,Value=demo,\
PropagateAtLaunch=true \
ResourceId=${jenkins_master_asg},\
ResourceType=auto-scaling-group,\
Key=webapp,Value=Apache,\
PropagateAtLaunch=true \
ResourceId=${jenkins_master_asg},\
ResourceType=auto-scaling-group,\
Key=CostCentre,Value=BAU,\
PropagateAtLaunch=true \
		&& echo -e "Successfull" \
		|| echo -e "Failed"; # Non fatal.. Information only
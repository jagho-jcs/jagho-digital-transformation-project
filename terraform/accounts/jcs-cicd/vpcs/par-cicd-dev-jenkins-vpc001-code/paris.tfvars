###############################################################################
# VPC Configuration
###############################################################################

create_vpc                    = true

# VPC CIDR 
vpc_cidr_block                = "10.0.11.0/24"

vpc_name                      = "par-cicd-dev-jenkins-vpc001"

vpc_role                      = "cicd"

###############################################################################
# Jenkins Application  Subnets
###############################################################################

# Creates a tag with key of 'Name' and a value that you specify
app_subnet_role               = "ingress"

app_route_table_role          = "Jenkins Private Route Table"

app_network_acl_name          = "jenkins"

app_network_acl_role          = "Jenkins Ingress Access Control List"

# Number of subnets required
app_subnets                   = 3

# Application CIDR block required
app_newbit_size               = 3

# This is a limitation in Terraform cidr function we need to specify where to 
# start to avoid overlapping errors
app_subnet_start              = 0

destination_cidr_block        = "0.0.0.0/0"

###############################################################################
# Default Security  Group - JCS-Network
# This security group should be created in all accounts
###############################################################################

# Creates a tag with key of 'Name' and a value that you specify
security_group_name           = "par-cicd-dev-jenkins-local-access-vpc001-sg001"

security_group_role           = "jcs Network Local Access"

ingress_ports                 = [ 0 ]

security_group_cidr_block     = "10.0.0.0/24"

security_group_description    = "Default Security Group to Allow Local Access to the jcs Network"

dynamic_ingress_description   = "jcs-NETWORK"
###############################################################################
# VPC Configuration
###############################################################################

create_vpc                    = true

# VPC CIDR
vpc_cidr_block                = "10.0.99.0/24"

vpc_name                      = "par-cicd-dev-poc-vpc002"

vpc_role                      = "Test POC"

destination_cidr_block        = "0.0.0.0/0"

###############################################################################
# Application  Subnets
###############################################################################

# Creates a tag with key of 'Name' and a value that you specify
app_subnet_name           = "app"

app_subnet_role           = "ingress"

app_route_table_role      = "Private Application Route Table"

app_network_acl_name      = "app"

app_network_acl_role      = "Test POC Applications Ingress Access Control List"

# Number of subnets required
app_subnets               = 3

# Web CIDR block required
app_newbit_size           = 3

# This is a limitation in Terraform cidr function we need to specify where to
# start to avoid overlapping errors
app_subnet_start          = 0

###############################################################################
# Web  Subnets
###############################################################################

# Creates a tag with key of 'Name' and a value that you specify
web_subnet_name           = "web"

web_subnet_role           = "ingress"

web_route_table_role      = "Private Application Route Table"

web_network_acl_name      = "web"

web_network_acl_role      = "Test POC Web Ingress Access Control List"

# Number of subnets required
web_subnets               = 3

# Web CIDR block required
web_newbit_size           = 3

# This is a limitation in Terraform cidr function we need to specify where to
# start to avoid overlapping errors
web_subnet_start          = 3

###############################################################################
# Web  Subnets
###############################################################################

# Creates a tag with key of 'Name' and a value that you specify
dbs_subnet_name           = "dbs"

dbs_subnet_role           = "ingress"

dbs_route_table_role      = "Private Database Route Table"

dbs_network_acl_name      = "dbs"

dbs_network_acl_role      = "Test POC Database Ingress Access Control List"

# Number of subnets required
dbs_subnets               = 3

# Web CIDR block required
dbs_newbit_size           = 4

# This is a limitation in Terraform cidr function we need to specify where to
# start to avoid overlapping errors
dbs_subnet_start          = 12

###############################################################################
# Default Security  Group - JCS-Network
# This security group should be created in all accounts
###############################################################################

# Creates a tag with key of 'Name' and a value that you specify
security_group_name           = "par-cicd-dev-poc-local-access-vpc002-sg001"

security_group_role           = "jcs Network Local Access"

ingress_ports                 = [ 0 ]

security_group_cidr_block     = "10.0.0.0/24"

security_group_description    = "Default Security Group to Allow Local Access to the jcs Network"

dynamic_ingress_description   = "jcs-NETWORK"

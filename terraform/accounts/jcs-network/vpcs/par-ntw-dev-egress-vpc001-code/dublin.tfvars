###############################################################################
# VPC Configuration
###############################################################################

# VPC CIDR 
vpc_cidr_block                = "10.0.2.0/24"

vpc_name                      = "par-ntw-vpc002"

vpc_role                      = "network-edge"

destination_cidr_block        = "0.0.0.0/0"

###############################################################################
# Public  Subnets
###############################################################################

# Creates a tag with key of 'Name' and a value that you specify
public_subnet_name            = "egress"

public_subnet_role            = "egress"

public_route_table_role       = "Network Edge Public Route Table"

internet_gateway_role         = "Network Edge Egress Internet Gateway"

public_network_acl_name       = "nacl002"

public_network_acl_role       = "Network Edge Egress Access Control List"

# Number of subnets required
public_subnets                = 3

# Application CIDR block required
public_newbit_size            = 3

# This is a limitation in Terraform cidr function we need to specify where to 
# start to avoid overlapping errors
public_subnet_start           = 3

###############################################################################
# Private  Subnets
###############################################################################

# Creates a tag with key of 'Name' and a value that you specify
private_subnet_name           = "ingress"

private_subnet_role           = "egress"

private_route_table_role      = "Network Edge Private Route Table"

private_network_acl_name      = "nacl002"

private_network_acl_role      = "Network Edge Ingress Access Control List"

# Number of subnets required
private_subnets               = 3

# Web CIDR block required
private_newbit_size           = 3

# This is a limitation in Terraform cidr function we need to specify where to 
# start to avoid overlapping errors
private_subnet_start          = 0

###############################################################################
# Default Security  Group - JCS-Network
# This security group should be created in all accounts
###############################################################################

# Creates a tag with key of 'Name' and a value that you specify
security_group_name           = "par-ntw-dev-local-access-vpc001-sg001"

security_group_role           = "JCS Network Local Access"

ingress_ports                 = [ 0 ]

security_group_cidr_block     = "10.0.0.0/24"

security_group_description    = "Default Security Group to Allow Local Access to the JCS Network"

dynamic_ingress_description   = "JCS-NETWORK"
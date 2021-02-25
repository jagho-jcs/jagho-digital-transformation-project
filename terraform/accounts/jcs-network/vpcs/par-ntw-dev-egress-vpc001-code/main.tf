###############################################################################
# AWS Provider!..
###############################################################################

# provider "aws" {
    
#     region  = var.region
#     version = "~> 2.22.0"

# }

###############################################################################
# Base Network
###############################################################################

module vpc {
  source = "../../../../modules/vpc"
  create_vpc                          = true
  
  manage_default_vpc                  = true
  default_vpc_name                    = "do not use!.."

  region                              = var.region
  vpc_name                            = var.vpc_name
  vpc_role                            = var.vpc_role
  vpc_cidr_block                      = var.vpc_cidr_block

  vpc_tags = merge(module.jcs-tags.jcs_aws_ntw_env_default_tags, map(
    "Name", format ("%s",var.vpc_name),
    "Role", var.vpc_role
    )
  ) 
###############################################################################
# Do Not Make any changes to the default_vpc_tags!!!
###############################################################################
  default_vpc_tags = merge(module.jcs-tags.jcs_aws_default_vpc_tags, map(
    "Name", format ("%s",var.default_vpc_name)
    )
  )
}

###############################################################################
# Public  Subnets
###############################################################################

module public-subnets {
  source = "../../../../modules/public-subnets"

  region                              = module.vpc.region
  vpc_id                              = module.vpc.id
  vpc_cidr_block                      = module.vpc.vpc_cidr_block
  destination_cidr_block              = var.destination_cidr_block  
  vpc_name                            = module.vpc.vpc_name
  public_subnets                      = var.public_subnets
  public_subnet_name                  = var.public_subnet_name
  public_newbit_size                  = var.public_newbit_size
  public_subnet_start                 = var.public_subnet_start
  public_subnet_role                  = var.public_subnet_role
  public_route_table_role             = var.public_route_table_role
  internet_gateway                    = var.internet_gateway
  internet_gateway_role               = var.internet_gateway_role
  nat_gateway_name                    = var.nat_gateway_name
  nat_gateway_role                    = var.nat_gateway_role
  elastic_ip_role                     = var.elastic_ip_role
  public_network_acl_name             = var.public_network_acl_name
  public_network_acl_role             = var.public_network_acl_role
  
  jcs_account_tags                   = module.jcs-tags.jcs_aws_ntw_env_default_tags  
}

###############################################################################
# Private  Subnets
###############################################################################

module private-subnets {
  source = "../../../../modules/private-subnets"
  
  region                              = module.vpc.region
  vpc_id                              = module.vpc.id
  vpc_cidr_block                      = module.vpc.vpc_cidr_block
  destination_cidr_block              = module.public-subnets.destination_cidr_block
  vpc_name                            = module.vpc.vpc_name
  private_subnets                     = var.private_subnets
  private_subnet_name                 = var.private_subnet_name
  private_newbit_size                 = var.private_newbit_size
  private_subnet_start                = var.private_subnet_start
  private_subnet_role                 = var.private_subnet_role
  private_route_table_role            = var.private_route_table_role
  private_network_acl_name            = var.private_network_acl_name
  private_network_acl_role            = var.private_network_acl_role
  
  jcs_account_tags                   = module.jcs-tags.jcs_aws_ntw_env_default_tags  
}

module security-groups {
  source = "../../../../modules/security-groups"

  vpc_id                              = module.vpc.id
  destination_cidr_block              = module.public-subnets.destination_cidr_block
  security_group_cidr_block           = var.security_group_cidr_block
  security_group_description          = var.security_group_description
  ingress_ports                       = var.ingress_ports
  dynamic_ingress_description         = var.dynamic_ingress_description
  security_group_name                 = var.security_group_name
  security_group_role                 = var.security_group_role
  
  jcs_account_tags                   = module.jcs-tags.jcs_aws_ntw_env_default_tags
}

###############################################################################
# jcs Global Tagging
###############################################################################

module jcs-tags {
  source = "../../../../modules/jcs-tags"

}
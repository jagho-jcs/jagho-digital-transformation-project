###############################################################################
# AWS Provider!..
###############################################################################

provider "aws" {


    region  = var.region
    version = "~> 2.60"

}

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

  vpc_tags = merge(module.jcs-tags.jcs_aws_cicd_dev_env_default_tags, map(
    "Name", format ("%s",var.vpc_name),
    "Role", var.vpc_role
    )
  )

  default_vpc_tags = merge(module.jcs-tags.jcs_aws_default_vpc_tags, map(
    "Name", format ("%s",var.default_vpc_name)
    )
  )
}

###############################################################################
# Application  Subnets
###############################################################################

module app-subnets {
  source = "../../../../modules/app-subnets"

  region                              = module.vpc.region
  vpc_name                            = module.vpc.vpc_name
  vpc_id                              = module.vpc.id
  vpc_cidr_block                      = module.vpc.vpc_cidr_block
  destination_cidr_block              = var.destination_cidr_block
  app_subnet_name                     = var.app_subnet_name
  app_subnet_role                     = var.app_subnet_role
  app_subnets                         = var.app_subnets
  app_newbit_size                     = var.app_newbit_size
  app_subnet_start                    = var.app_subnet_start
  app_route_table_role                = var.app_route_table_role
  app_network_acl_name                = var.app_network_acl_name
  app_network_acl_role                = var.app_network_acl_role

  jcs_account_tags                   = module.jcs-tags.jcs_aws_cicd_dev_env_default_tags
}

###############################################################################
# Web  Subnets
###############################################################################

module web-subnets {
  source = "../../../../modules/web-subnets"

  region                              = module.vpc.region
  vpc_name                            = module.vpc.vpc_name
  vpc_id                              = module.vpc.id
  vpc_cidr_block                      = module.vpc.vpc_cidr_block
  destination_cidr_block              = module.app-subnets.destination_cidr_block
  web_subnet_name                     = var.web_subnet_name
  web_subnet_role                     = var.web_subnet_role
  web_subnets                         = var.web_subnets
  web_newbit_size                     = var.web_newbit_size
  web_subnet_start                    = var.web_subnet_start
  web_route_table_role                = var.web_route_table_role
  web_network_acl_name                = var.web_network_acl_name
  web_network_acl_role                = var.web_network_acl_role

  jcs_account_tags                   = module.jcs-tags.jcs_aws_cicd_dev_env_default_tags
}

###############################################################################
# Database  Subnets
###############################################################################

module dbs-subnets {
  source = "../../../../modules/dbs-subnets"

  region                              = module.vpc.region
  vpc_name                            = module.vpc.vpc_name
  vpc_id                              = module.vpc.id
  vpc_cidr_block                      = module.vpc.vpc_cidr_block
  destination_cidr_block              = module.app-subnets.destination_cidr_block
  dbs_subnet_name                     = var.dbs_subnet_name
  dbs_subnet_role                     = var.dbs_subnet_role
  dbs_subnets                         = var.dbs_subnets
  dbs_newbit_size                     = var.dbs_newbit_size
  dbs_subnet_start                    = var.dbs_subnet_start
  dbs_route_table_role                = var.dbs_route_table_role
  dbs_network_acl_name                = var.dbs_network_acl_name
  dbs_network_acl_role                = var.dbs_network_acl_role

  jcs_account_tags                   = module.jcs-tags.jcs_aws_cicd_dev_env_default_tags
}

module security-groups {
  source = "../../../../modules/security-groups"

  vpc_id                              = module.vpc.id
  destination_cidr_block              = module.app-subnets.destination_cidr_block
  security_group_cidr_block           = var.security_group_cidr_block
  security_group_description          = var.security_group_description
  ingress_ports                       = var.ingress_ports
  dynamic_ingress_description         = var.dynamic_ingress_description
  security_group_name                 = var.security_group_name
  security_group_role                 = var.security_group_role

  jcs_account_tags                   = module.jcs-tags.jcs_aws_cicd_dev_env_default_tags
}

###############################################################################
# jcs Global Tagging Module
###############################################################################

module jcs-tags {
  source = "../../../../modules/jcs-tags"

}

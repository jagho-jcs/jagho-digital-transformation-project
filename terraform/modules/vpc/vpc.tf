###########################################################
# This is where we define our VPC
###########################################################

resource aws_vpc this {
  count = var.create_vpc ? 1 : 0

  cidr_block                = var.vpc_cidr_block
  enable_dns_hostnames      = true

  tags = var.vpc_tags 
}

###########################################################
# This is where we manage the Default VPC
###########################################################

resource aws_default_vpc this {
  count = var.manage_default_vpc ? 1 : 0

  enable_dns_support   = var.default_vpc_enable_dns_support
  enable_dns_hostnames = var.default_vpc_enable_dns_hostnames
  enable_classiclink   = var.default_vpc_enable_classiclink

  tags = var.default_vpc_tags
}
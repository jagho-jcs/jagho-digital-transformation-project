output vpc_name {
  value = module.vpc.vpc_name
}

output region {
  value = module.vpc.region
}

output vpc_cidr_block {
  value = module.vpc.vpc_cidr_block
}

output application_cidrs {
  value = module.app-subnets.application_cidrs
}

output web_cidrs {
  value = module.web-subnets.web_cidrs
}

output database_cidrs {
  value = module.dbs-subnets.database_cidrs
}

output security_group_name {
  value = module.security-groups.security_group_name
}

output security_group_cidr_block {
  value = module.security-groups.security_group_cidr_block
}

output security_group_role {
  value = module.security-groups.security_group_role
}
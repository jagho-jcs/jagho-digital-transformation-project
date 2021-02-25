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
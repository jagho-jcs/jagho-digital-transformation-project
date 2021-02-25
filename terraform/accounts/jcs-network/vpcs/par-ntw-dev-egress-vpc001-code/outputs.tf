output vpc_name {
  value = module.vpc.vpc_name
}

output region {
  value = module.vpc.region
}

output vpc_cidr_block {
  value = module.vpc.vpc_cidr_block
}

output public_cidrs {
  value = module.public-subnets.public_cidrs
}

output private_cidrs {
  value = module.private-subnets.private_cidrs
}
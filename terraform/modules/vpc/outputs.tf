## Variables being exported for downstream consumption

output region {
  value = var.region
}

output vpc_cidr_block {
  value = var.vpc_cidr_block
}

output vpc_name {
  value = var.vpc_name
}

output id {
  value       = concat(aws_vpc.this.*.id, [""])[0]
}
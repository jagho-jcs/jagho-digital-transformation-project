###############################################################################
# Expected values from the caller
###############################################################################
variable create_vpc {
  description = "Controls if VPC should be created (it affects almost all resources)"
  type        = bool
  default     = false
}
variable region {}
variable vpc_cidr_block {}
variable vpc_name {}
variable vpc_role {}
variable default_vpc_name {
  type = "string"
  description = "describe your variable"
  default = "do not use!.."
}

variable destination_cidr_block {}
variable app_subnets {}

variable app_subnet_name {
  type = "string"
  description = "describe your variable"
  default = "app"
}

variable app_subnet_role {}
variable app_newbit_size {}
variable app_subnet_start {}
variable app_route_table_role {}
variable app_network_acl_name {}
variable app_network_acl_role {}

variable security_group_name {}
variable security_group_description {}
variable security_group_cidr_block {}
variable dynamic_ingress_description {}
variable ingress_ports {}
variable security_group_role {}
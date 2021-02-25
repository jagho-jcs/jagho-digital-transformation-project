variable create_vpc {}
variable region {}
variable vpc_cidr_block {}
variable vpc_name {}
variable vpc_role {}
variable default_vpc_name {

  default = "do not use!.."
}
variable destination_cidr_block {}

variable vpc_id {
  
  default = ""

}



variable internet_gateway {

  default = ""
}


variable public_subnets {}
variable public_subnet_name {}
variable public_subnet_role {}
variable public_newbit_size {}
variable public_subnet_start {}
variable public_route_table_role {}
variable internet_gateway_role {}
variable nat_gateway_name {}
variable nat_gateway_role {

  default = "Egress Internet Gateway"

}
variable elastic_ip_role {}
variable public_network_acl_name {}
variable public_network_acl_role {}
variable private_subnets {}
variable private_subnet_name {}
variable private_newbit_size {}
variable private_subnet_start {}
variable private_subnet_role {}
variable private_route_table_role {}
variable private_network_acl_name {}
variable private_network_acl_role {}
variable security_group_name {}
variable security_group_description {}
variable security_group_cidr_block {}
variable dynamic_ingress_description {}
variable ingress_ports {}
variable security_group_role {}
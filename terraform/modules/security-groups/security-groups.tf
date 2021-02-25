resource aws_security_group this {

  name              = var.security_group_name
  description       = var.security_group_description
  vpc_id            = var.vpc_id

  dynamic ingress {
    iterator        = port
    for_each        = var.ingress_ports
    content {
      description   = var.dynamic_ingress_description
      from_port     = port.value
      to_port       = port.value
      protocol      = -1
      cidr_blocks   = [ var.security_group_cidr_block ]
    }
  }
  ingress {
      description   = "Ingress-With-Self"
      protocol      = -1
      self          = true
      from_port     = 0
      to_port       = 0
  }
  egress {
      from_port     = 0
      to_port       = 0
      protocol      = -1
      cidr_blocks   = [ var.destination_cidr_block ]
  }

  tags = merge(
    {
      "Name" = var.security_group_name
      "Role" = var.security_group_role
    },
    var.jcs_account_tags,
  )
}
data aws_availability_zones all {}

resource aws_subnet this {

  count                       = var.public_subnets

  vpc_id                      = var.vpc_id
 
  cidr_block                  = cidrsubnet(var.vpc_cidr_block, var.public_newbit_size, count.index + var.public_subnet_start)

  availability_zone           = element(data.aws_availability_zones.all.names, count.index)

  map_public_ip_on_launch     = true

  tags = merge(
    {
      "Name" = "${var.vpc_name}-${var.public_subnet_name}${"public-az"}-${count.index +1}",
      "Role" = var.public_subnet_role
    },
    var.jcs_account_tags,
  )
}

resource aws_route_table this {
  vpc_id = var.vpc_id

  tags = merge(
    {
      "Name" = "${var.vpc_name}-${var.public_subnet_name}-${"public-rtb"}",
      "Role" = var.public_route_table_role
    },
    var.jcs_account_tags,
  )
}

resource aws_route_table_association this {
  
  count                       = length(data.aws_availability_zones.all.names)

  subnet_id                   = element(aws_subnet.this.*.id, count.index)
  
  route_table_id              = aws_route_table.this.id

}

resource aws_internet_gateway this {
  vpc_id                      = var.vpc_id
  
  tags = merge(
    {
      "Name" = "${var.vpc_name}-${var.public_subnet_name}-${"igw"}",
      "Role" = var.internet_gateway_role
    },
    var.jcs_account_tags,
  )
}

resource aws_eip this {
  count                       = length(data.aws_availability_zones.all.names)

  vpc                         = true

  tags = merge(
    {
      "Name" = "${var.vpc_name}-${var.nat_gateway_name}${"eip"}-${count.index +1}",
      "Role" = var.elastic_ip_role
    },
    var.jcs_account_tags,
  )
}

resource aws_nat_gateway this {
  count                       = length(data.aws_availability_zones.all.names)
  
  allocation_id               = element(aws_eip.this.*.id, count.index)
  subnet_id                   = element(aws_subnet.this.*.id, count.index)

  depends_on                  = [ aws_internet_gateway.this ]

  tags = merge(
    {
      "Name" = "${var.vpc_name}-${"az"}${count.index + 1}-${var.nat_gateway_name}",
      "Role" = var.nat_gateway_role
    },
    var.jcs_account_tags,
  )
}

# Grant the VPC internet access on its main route table
resource aws_route this {

  route_table_id              = aws_route_table.this.id
  destination_cidr_block      = var.destination_cidr_block
  gateway_id                  = aws_internet_gateway.this.id
}

resource aws_network_acl this {
  
  vpc_id                      = var.vpc_id
  
  subnet_ids                  = aws_subnet.this.*.id 

/* This needs to be changeed to a resource type to allow for 
    future ports to be added and tested in different 
    environment!...*/
  ingress {    /* Rule # 100*/
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = var.destination_cidr_block
    from_port  = 0
    to_port    = 0
  }  

  egress {     /* Rule 100 */
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = var.destination_cidr_block
    from_port  = 0
    to_port    = 0
  }

  tags = merge(
    {
      "Name" = "${var.vpc_name}-${var.public_subnet_name}-${var.public_network_acl_name}",
      "Role" = var.public_network_acl_role
    },
    var.jcs_account_tags,
  )
}
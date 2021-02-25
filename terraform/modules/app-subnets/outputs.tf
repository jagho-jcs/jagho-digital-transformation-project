output destination_cidr_block {
  value = var.destination_cidr_block
}

output application_cidrs {
  value = aws_subnet.this.*.cidr_block
}
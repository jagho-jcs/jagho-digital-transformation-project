output private_cidrs {
  value = aws_subnet.this.*.cidr_block
}
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
variable vpc_tags {}

variable manage_default_vpc {
  description = "Should be true to adopt and manage Default VPC"
  type        = bool
  default     = false
}

variable default_vpc_name {
  description = "Name to be used on the Default VPC"
  type        = string
  default     = ""
}

variable default_vpc_enable_dns_support {
  description = "Should be true to enable DNS support in the Default VPC"
  type        = bool
  default     = true
}

variable default_vpc_enable_dns_hostnames {
  description = "Should be true to enable DNS hostnames in the Default VPC"
  type        = bool
  default     = true
}

variable default_vpc_enable_classiclink {
  description = "Should be true to enable ClassicLink in the Default VPC"
  type        = bool
  default     = false
}

variable jcs_aws_default_vpc_tags {
  type        = map(string)
  description = "Tags to be applied to the VPC created in the AWS JCS environment"
  default = {}
}

variable jcs_aws_ntw_env_default_tags {
  type        = map(string)
  description = "Default tags to be applied to all resources created in the Network-Edge"
  default = {}
}

variable jcs_aws_cicd_dev_env_default_tags {
  type        = map(string)
  description = "Default tags to be applied to all resources created in the CI-CD"
  default = {}
}

variable jcs_aws_sss_prd_env_default_tags {
  type        = map(string)
  description = "Default tags to be applied to all resources created in Shared Services"
  default = {}
}

variable default_vpc_tags {
  type        = map(string)
  description = "Default tags to be applied to the default VPC created in the JCS AWS environment"
  default = {}
}

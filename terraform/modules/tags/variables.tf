#########################################################################################
# JCS Global Tags that will be applied to all Default VPC's in the AWS Environment
#########################################################################################
variable jcs_aws_default_vpc_tags {
  type        = map(string)
  description = "Default tags to be applied to the AWS default VPC"
  default = {
    ProductOwner      = "AWS"
    ProvisionedBy     = "Amazon Web Services"
    ProvisioningTool  = "Terraform"
  }
}
#########################################################################################
# JCS Global tags to be applied to all AWS resources created in the Network-Edge
#########################################################################################
variable jcs_aws_ntw_env_default_tags {
  type        = map(string)
  description = "Default tags to be applied to all resources created in the AWS jcs environment"
  default = {
    ProductOwner        = "Yomi Ogunyinka"
    BusinessUnit        = "dev"
    CostCentre          = "Not Applicable"
    DataCentre          = "Paris"
    Email               = "Yomi.O@JaghoConsultants.co.uk"
    Project             = "IaC"
    ProvisioningTool    = "Terraform"
  }
}
#########################################################################################
# Global tags to be applied to all AWS resources created in CI-CD
#########################################################################################
variable jcs_aws_cicd_dev_env_default_tags {
  type        = map(string)
  description = "Default tags to be applied to all resources created in Shared Services"
  default = {
    ProductOwner        = "Yomi Ogunyinka"
    BusinessUnit        = "dev"
    CostCentre          = "Not Applicable"
    DataCentre          = "Paris"
    Email               = "Yomi.O@JaghoConsultants.co.uk"
    Project             = "IaC"
    ProvisioningTool    = "Terraform"
  }
}

#########################################################################################
# Global tags to be applied to all AWS resources created in Shared-Services
#########################################################################################
variable jcs_aws_sss_prd_env_default_tags {
  type        = map(string)
  description = "Default tags to be applied to all resources created in Shared Services"
  default = {
    ProductOwner        = "Yomi Ogunyinka"
    BusinessUnit        = "prd"
    CostCentre          = "Not Applicable"
    DataCentre          = "Paris"
    Email               = "Yomi.O@JaghoConsultants.co.uk"
    Project             = "Common-Infra"
    ProvisioningTool    = "Terraform"
  }
}

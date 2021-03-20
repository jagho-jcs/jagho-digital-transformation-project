locals {

  bucket_name     = var.bucket
  key_name        = "jcs-cicd-iac/terraform.tfstate"

}

module "s3_bucket" {
  source = "../../../modules/s3"
  
  bucket        = local.bucket_name
  region        = var.region

  acl           = "private"
  force_destroy = false

  attach_policy = true
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [{
      "Sid": "ListBucket",
      "Effect": "Allow",
      "Principal": {
        "AWS": [
          "arn:aws:iam::123456789012:user/jenkinsusr"
        ]
      },
      "Action": "s3:ListBucket",
      "Resource": "arn:aws:s3:::${local.bucket_name}"
    },
    {
      "Sid": "CreateGetPutObject",
      "Effect": "Allow",
      "Principal": {
        "AWS": [
          "arn:aws:iam::123456789012:user/jenkinsusr"
        ]
      },
      "Action": [
        "s3:GetObject",
        "s3:PutObject"
      ],
      "Resource": "arn:aws:s3:::${local.bucket_name}/${local.key_name}"
    }
  ]
}
EOF

    tags = {
      
      ProductOwner        = "Yomi Ogunyinka"
      BusinessUnit        = "dev"
      CostCentre          = "Not Applicable"
      DataCentre          = "Paris"
      Email               = "Yomi.O@JaghoConsultants.co.uk"
      Project             = "IaC"
      ProvisioningTool    = "Terraform"
    
    }

    versioning = {
      enabled = true
    }
  }
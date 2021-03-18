# JCS AWS VPC Terraform module

Terraform module that creates VPC resources in AWS

## What is an AMAZON VPC?

Amazon Virtual Private Cloud (Amazon VPC) enables you to launch AWS resources into a virtual network that you've defined. This virtual network closely resembles a traditional network that you'd operate in your own data center, with the benefits of using the scalable infrastructure of AWS.

## Creating a VPC with Public and Subnets for Your Compute Environment

Compute resources in your compute environments need external network access to communicate with the Amazon ECS service endpoint. However, you might have jobs that you would like to run in private subnets. Creating a VPC with both public and private subnets provides you the flexibility to run jobs in either a public or private subnet. Jobs in the private subnets can access the internet through a `NAT` gateway.

### Requirements

| Name | 	Version |
|------|-------------|
| terraform| >=0.12.21 |
| aws | >=3.10 |

### Providers

| Name | 	Version |
|------|-------------|
| aws | >=3.10 |

### Modules

| Name | 	Source | Version |
|------|-----------| --------|
| vpc  | ../.. 	   |         |
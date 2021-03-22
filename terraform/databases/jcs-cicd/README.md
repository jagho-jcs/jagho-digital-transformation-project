# What is Amazon DynamoDB?

**Amazon DynamoDB** is a key-value and document database that delivers single-digit millisecond performance at any scale. It's a fully managed, multiregion, multimaster database with built-in security, backup and restore, and in-memory caching for internet-scale applications. 

**DynamoDB** can handle more than 10 trillion requests per day and support peaks of more than 20 million requests per second.

## Multi-account AWS Architecture

A common architectural pattern is for an organization to use a number of separate AWS accounts to isolate different teams and environments. 

For example, a `staging` system will often be deployed into a separate AWS account than its corresponding `production` system, to minimize the risk of the staging environment affecting production infrastructure, whether via rate limiting, misconfigured access controls, or other unintended interactions.

**DynamoDB** can be used as a locking mechanism to remote storage `backend S3` to store state files. 

The **DynamoDB** table is keyed on `LockID` which is set as a bucketName/path, so as long as we have a unique combination of this we don’t have any problem in acquiring locks and running everything in a safe way.

The S3 backend can be used in a number of different ways that make different tradeoffs between convenience, security, and isolation in such an organization.

Terraform helps us build, evolve, and manage our infrastructure using its configuration files across multiple providers. 

When we build infrastructure with terraform configuration, a state file gets created in the local workspace directory named `terraform.tfstate`. This state file contains information about the provisioned infrastructure which terraform manage. 

Whenever we change the configuration file, it automatically determines which part of your configuration is already created and which needs to be changed with the help of this state file, `terraform-state` helps provide idempotence to terraform as it already knows if one resource is present and prevents it from being created again when the same configuration executes.
# JCS Digital Transformation Project

## Repository Information

This repository contains all the information and automation necessary to provision Infrastructure in AWS.

Please note we have a [code of conduct](CODE_OF_CONDUCT.md), please follow it in all your interactions with the project.

## Structure of the repository :card_index:

| Folder | Content |
| ------ | ------- |
| iam-policies | Custom iam policies that we use at JCS |
| infra-config | All configuration files for our RDS clusters and the network |
| bash-scripts | Scripts for environment clean-up |
| terraform | Terraform scripts that will be triggered to spin up infra in AWS  |

### How to use this repository

Any resource created by this repository will mean using Terraform. In this repository we have automation to create 
virtual private cloud networks (VPCs), subnets, security groups, load balancers, auto-scaling groups and much more,
basically the whole environment.

Ideally, no one should be running the Terraform scripts directly. Terraform generates status files and Amazon Machine
Image (AMI) versions that need to be managed centrally. If different people clone the repository and run Terraform from their
laptops, they could be wiping instances and services in AWS created by other people, because Terraform cannot handle
concurrency at all.

Therefore, we need to run all the automation from a centralised point, using a Jenkins server:

https://jenkins.dev.jagho.tk

### Infrastructure as code

Everything in AWS will be in Git, from documentation to spin up and run environments to all the automation to create,
install and configure everything. Nothing is supposed to be provisioned manually.

* **_https://gitlab.dev.jagho.tk/Yomi.Ogunyinka/jagho-digital-transformation-project_** (this one)<br/>
This repository contains all the automation to provision infrastructure in AWS. This will configure the network,
create the database cluster, configure all the load balancers, etc.

### JCS Terraform Modules

This directory contains all the terraform modules required to build out JCS AWS Infrastructure.

### Requirements

Each module should have its own folder in the repository.

It should not be specific to any service or application and should be generic/vanilla and re-usable as possible.

Make sure every argument is parameterized. Do not hard code maps which may be different for other use cases (for example the lambda argument "environment"), instead create a variable map.

Add conditions where appropriate - for example S3 resources that require CORRS.. you can not add this as an option, you will need to add a condition on the resource, then add another resource to create without CORRS.

Create defaults as much as possible so we can make our stacks light. Make use of locals so we can also set conditions to determines what another value should be. This will help reduce the amount of code needed.

That being said, keep things simple, clean and easy to read/use.

DO NOT - create dependencies with the module, it should not under any circumstance link with any other module/folder in this or any other repository.

Make sure these modules are written and compatible with terraform 0.12.*
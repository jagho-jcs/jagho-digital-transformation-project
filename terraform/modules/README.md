# Modules - Terraform by HashiCorp

Modules can be used to create lightweight abstractions, so that you can describe your infrastructure in terms off its architecture, rather than directly in terms of physical objects. The `.tf` files in your working directory when you run `terraform plan` or `terraform apply` together form the root module.

## Module Structure

Re-usable modules are defined using all of the same configuration language concepts we use in root modules.

- **Input variables** to accept values from the calling module

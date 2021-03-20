###############################################################################
# Expected values from the caller
###############################################################################
variable region {
  type          = "string"
  description   = "AWS Region"
}
variable bucket {
  description   = "(Optional, Forces new resource) The name of the bucket. If omitted, Terraform will assign a random, unique name."
  type          = "string"
}
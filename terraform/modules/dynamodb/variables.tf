variable region {}

# variable "profile" {
#   default = "jcs-network"
# }

variable tbl_name {
  type = "string"
  description = "describe your variable"
  default = null
}
variable tbl_hash_key {
  type = "string"
  description = "describe your variable"
  default = null
}
variable tbl_read_capacity {
  type = "string"
  description = "describe your variable"
  default = null
}
variable tbl_write_capacity {
  type = "string"
  description = "describe your variable"
  default = null
}
variable table_tags {
  description = "(Optional) A mapping of tags to assign to the bucket."
  type        = map(string)
  default     = {}
}
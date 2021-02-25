# create a dynamodb table for locking the state file
resource "aws_dynamodb_table" "dynamodb-tf-state-lock" {
  
  name            = var.tbl_name
  hash_key        = var.tbl_hash_key
  read_capacity   = var.tbl_read_capacity
  write_capacity  = var.tbl_write_capacity
  tags            = var.table_tags
 
  attribute {
    name = "LockID"
    type = "S"
  }
}
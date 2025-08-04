resource "aws_dynamodb_table" "lock-dynamodb-table" {
  name           = "LockTable-DynamoDB"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"
  
  attribute {
    name = "LockID"
    type = "S"
  }

  attribute {
    name = "LockID"
    type = "S"
  }
  tags = {
    Name        = "dynamodb-table-lock"
  }
}
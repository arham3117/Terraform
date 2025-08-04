resource "aws_dynamodb_table" "my_dynamodb_table" {
  name           = "${var.env}-infra-app-dynamodb-table"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = var.hash_key
  
  attribute {
    name = var.hash_key
    type = "S"
  }

  tags = {
    Name        = "${var.env}-infra-app-dynamodb-table"
    Environment = var.env
  }
}
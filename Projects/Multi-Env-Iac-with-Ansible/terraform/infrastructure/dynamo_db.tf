# THis is the code for creating a DynamoDB table using Terraform
resource "aws_dynamodb_table" "my_table" {
    name         = "${var.env}-arh-dynamodb-table"
    billing_mode = "PAY_PER_REQUEST"
    hash_key     = "userID"

    attribute {
        name = "userID"
        type = "S"
    }

    tags = {
        Name        = "${var.env}-arh-dynamodb-table"
        Environment = var.env
    }
}

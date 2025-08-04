# This is code for s3 bucket

resource "aws_s3_bucket" "my_s3" {
  bucket = "arh-tf-state-bucket"

  tags = {
    Name        = "my-terraform-state"
  }
}
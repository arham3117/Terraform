# This is the code for my s3 bucket

resource "aws_s3_bucket" "my_bucket" {
    bucket = "${var.env}-arh-s3-bucket"
    tags = {
        Name = "${var.env}-arh-s3-bucket"
        Environment = var.env
    }
}
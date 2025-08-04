resource "aws_s3_bucket" "remote-s3" {
    bucket = "terraform-remote-state-bucket-lock"
    tags = {
        Name = "Terraform Remote State Bucket"
    }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
   backend "s3" {
    bucket = "arh-tf-state-bucket"
    key = "terraform.tfstate"
    region = "us-east-2"
  }
}

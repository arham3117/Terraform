terraform {
  # Specify minimum required Terraform version and provider versions
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"  # Use AWS provider version 6.x
    }
  }

  backend "s3" {
    bucket = "arh-s3-backend-static-website-with-cloudfront"
    key    = "static-website-cloudfront/terraform.tfstate"
    region = "us-east-2"
  }
}
 provider "aws" {
   region = var.primary
   alias = "primary"
 }
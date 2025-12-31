# Terraform Configuration
# Defines required providers and remote state backend

terraform {
  # Specify AWS provider version constraint
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  # Remote state backend using S3
  # Enables team collaboration and state locking
  backend "s3" {
    bucket = "arh-s3-backend-static-website-with-cloudfront"
    key    = "static-website-cloudfront/terraform.tfstate"
    region = "us-east-2"
  }
}

# AWS Provider Configuration
# Primary region for resource deployment
provider "aws" {
  region = "us-east-2"
}
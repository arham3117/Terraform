# ============================================================================
# Terraform Configuration
# ============================================================================
# This file configures Terraform settings, required providers, and AWS
# provider configurations for multi-region VPC peering deployment.

terraform {
  # Specify minimum required Terraform version and provider versions
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"  # Use AWS provider version 6.x
    }
  }

  # Configure remote state backend using S3
  # This enables state locking and team collaboration
  # State file is stored remotely for better security and accessibility
  backend "s3" {
    bucket = "arh-s3-backend-static-website-with-cloudfront"
    key    = "static-website-cloudfront/terraform.tfstate"
    region = "us-east-2"
  }
}

# ============================================================================
# AWS Provider Configuration - Primary Region (us-east-1)
# ============================================================================
# This provider is used for resources in the primary VPC region
# All resources using this provider will be created in us-east-1
provider "aws" {
  region = "us-east-1"
  alias  = "primary"
}

# ============================================================================
# AWS Provider Configuration - Secondary Region (us-west-2)
# ============================================================================
# This provider is used for resources in the secondary VPC region
# All resources using this provider will be created in us-west-2
provider "aws" {
  region = "us-west-2"
  alias  = "secondary"
}
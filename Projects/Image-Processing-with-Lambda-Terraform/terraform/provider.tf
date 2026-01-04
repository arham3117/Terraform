# ==============================================================================
# TERRAFORM AND PROVIDER CONFIGURATION
# ==============================================================================

terraform {
  required_version = ">= 1.0"

  required_providers {
    # AWS provider for S3, Lambda, IAM, and CloudWatch resources
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    # Archive provider for packaging Lambda function code
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.4"
    }
    # Random provider for generating unique resource identifiers
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

# AWS provider configuration with automatic resource tagging
provider "aws" {
  region = var.aws_region

  # Apply consistent tags to all resources for organization and cost tracking
  default_tags {
    tags = {
      Project     = "ImageProcessingApp"
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  }
}
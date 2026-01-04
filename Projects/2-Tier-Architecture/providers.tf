# ==============================================================================
# Terraform and Provider Configuration
# ==============================================================================
# Defines Terraform version constraints and configures AWS provider settings
# for the 2-tier architecture deployment
# ==============================================================================

terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure AWS provider with region from variable
provider "aws" {
  region = var.aws_region
}

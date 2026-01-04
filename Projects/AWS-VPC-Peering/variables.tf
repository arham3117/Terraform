# ============================================================================
# Variable Definitions
# ============================================================================
# This file defines all input variables used across the Terraform configuration
# for the AWS VPC Peering infrastructure deployment.

# ----------------------------------------------------------------------------
# Environment Configuration
# ----------------------------------------------------------------------------
variable "environment" {
  description = "Environment name for resource tagging (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"
}

# ----------------------------------------------------------------------------
# AWS Region Configuration
# ----------------------------------------------------------------------------
# Primary region where the first VPC will be created
variable "primary" {
  description = "AWS region for the primary VPC"
  type        = string
  default     = "us-east-1"
}

# Secondary region where the second VPC will be created
variable "secondary" {
  description = "AWS region for the secondary VPC"
  type        = string
  default     = "us-west-2"
}

# ----------------------------------------------------------------------------
# VPC CIDR Block Configuration
# ----------------------------------------------------------------------------
# CIDR blocks must not overlap for VPC peering to work properly
variable "primary_vpc_cidr" {
  description = "CIDR block for the primary VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "secondary_vpc_cidr" {
  description = "CIDR block for the secondary VPC"
  type        = string
  default     = "10.1.0.0/16"
}

# ----------------------------------------------------------------------------
# EC2 Instance Configuration
# ----------------------------------------------------------------------------
variable "instance_type" {
  description = "EC2 instance type for test instances in both VPCs"
  type        = string
  default     = "t2.micro"
}

# ----------------------------------------------------------------------------
# SSH Key Pair Configuration
# ----------------------------------------------------------------------------
# These key pairs must exist in their respective regions before deployment
variable "primary_key_name" {
  description = "Name of the SSH key pair in the primary region (us-east-1)"
  type        = string
  default     = "vpc-peering-east"
}

variable "secondary_key_name" {
  description = "Name of the SSH key pair in the secondary region (us-west-2)"
  type        = string
  default     = "vpc-peering-west"
}
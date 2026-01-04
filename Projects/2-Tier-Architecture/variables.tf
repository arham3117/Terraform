# ==============================================================================
# Day 22 - RDS Database Mini Project
# Variable Definitions
# ==============================================================================
# This file defines all input variables for the 2-tier architecture including
# general settings, networking configuration, EC2 instance specs, and RDS
# database parameters with sensible defaults for development environments
# ==============================================================================

# ------------------------------------------------------------------------------
# General Configuration Variables
# ------------------------------------------------------------------------------
variable "project_name" {
  description = "Name of the project - used for tagging resources"
  type        = string
  default     = "day22-rds-demo"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

# ------------------------------------------------------------------------------
# VPC Networking Variables
# ------------------------------------------------------------------------------
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets (minimum 2 required for RDS multi-AZ deployment)"
  type        = list(string)
  default     = ["10.0.2.0/24", "10.0.3.0/24"]
}

# ------------------------------------------------------------------------------
# EC2 Instance Variables
# ------------------------------------------------------------------------------
variable "ec2_instance_type" {
  description = "EC2 instance type for web server (t2.micro eligible for AWS free tier)"
  type        = string
  default     = "t2.micro"
}

# ------------------------------------------------------------------------------
# RDS Database Variables
# ------------------------------------------------------------------------------
variable "db_name" {
  description = "Name of the database"
  type        = string
  default     = "webappdb"
}

variable "db_username" {
  description = "Database master username (password auto-generated via Secrets Manager)"
  type        = string
  default     = "admin"
  sensitive   = true
}

variable "db_instance_class" {
  description = "RDS instance class (db.t3.micro eligible for AWS free tier)"
  type        = string
  default     = "db.t3.micro"
}

variable "db_allocated_storage" {
  description = "Allocated storage for RDS database in gigabytes"
  type        = number
  default     = 10
}

variable "db_engine_version" {
  description = "MySQL engine version"
  type        = string
  default     = "8.0"
}
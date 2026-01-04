# ==============================================================================
# INPUT VARIABLES - CONFIGURABLE INFRASTRUCTURE PARAMETERS
# ==============================================================================

variable "aws_region" {
  description = "AWS region where all infrastructure resources will be deployed"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Deployment environment identifier (e.g., dev, staging, prod) for resource naming and tagging"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Base name for resource identification, combined with environment to create unique names"
  type        = string
  default     = "image-processor"
}

variable "lambda_timeout" {
  description = "Maximum execution time for Lambda function in seconds (max: 900)"
  type        = number
  default     = 60
}

variable "lambda_memory_size" {
  description = "Memory allocation for Lambda function in MB (range: 128-10240, affects CPU allocation)"
  type        = number
  default     = 1024
}

variable "allowed_origins" {
  description = "CORS allowed origins for cross-origin requests (use specific domains in production)"
  type        = list(string)
  default     = ["*"]
}
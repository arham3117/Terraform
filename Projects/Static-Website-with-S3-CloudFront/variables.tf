# Input Variables
# Centralized configuration for customizable parameters

# S3 bucket name for hosting static website files
# Must be globally unique across all AWS accounts
variable "bucket_name" {
  description = "Name of the S3 bucket for static website hosting"
  type        = string
  default     = "arh-static-website-bucket"
}
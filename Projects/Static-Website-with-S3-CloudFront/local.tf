# Local Values
# Computed values used across multiple resources

locals {
  # CloudFront origin identifier for S3 bucket
  # Used to reference the origin in distribution configuration
  s3_origin_id = "s3-${aws_s3_bucket.f-s3-bucket.id}"
}
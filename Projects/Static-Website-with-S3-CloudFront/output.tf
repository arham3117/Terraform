# ========================================
# Output Values
# ========================================
# These values are displayed after terraform apply
# Use them to access your deployed resources

# Complete HTTPS URL for accessing the website
output "website_url" {
  description = "CloudFront distribution URL for the website"
  value       = "https://${aws_cloudfront_distribution.s3_distribution.domain_name}"
}

# CloudFront domain name (without https://)
output "cloudfront_domain_name" {
  description = "CloudFront distribution domain name"
  value       = aws_cloudfront_distribution.s3_distribution.domain_name
}

# Distribution ID for CloudFront operations (cache invalidation, etc.)
output "cloudfront_distribution_id" {
  description = "CloudFront distribution ID"
  value       = aws_cloudfront_distribution.s3_distribution.id
}

# S3 bucket name for reference
output "s3_bucket_name" {
  description = "S3 bucket name hosting the static files"
  value       = aws_s3_bucket.f-s3-bucket.bucket
}

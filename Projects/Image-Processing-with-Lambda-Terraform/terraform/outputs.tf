# ==============================================================================
# OUTPUT VALUES - DEPLOYMENT INFORMATION AND USAGE INSTRUCTIONS
# ==============================================================================

output "upload_bucket_name" {
  description = "Source S3 bucket name where users upload original images for processing"
  value       = aws_s3_bucket.upload_bucket.id
}

output "processed_bucket_name" {
  description = "Destination S3 bucket name containing processed image variants (5 per upload)"
  value       = aws_s3_bucket.processed_bucket.id
}

output "lambda_function_name" {
  description = "Name of the Lambda function handling image processing operations"
  value       = aws_lambda_function.image_processor.function_name
}

output "region" {
  description = "AWS region where all infrastructure resources are deployed"
  value       = var.aws_region
}

output "upload_command_example" {
  description = "AWS CLI command example for uploading an image to trigger processing"
  value       = "aws s3 cp your-image.jpg s3://${aws_s3_bucket.upload_bucket.id}/"
}
# Serverless Image Processing Pipeline with AWS Lambda

## Overview

This project implements a fully automated serverless image processing pipeline using AWS Lambda, S3, and Terraform. When an image is uploaded to the source S3 bucket, it automatically triggers a Lambda function that processes the image into multiple formats and resolutions, storing the results in a separate bucket.

## Architecture

The infrastructure implements an event-driven serverless architecture:

**Workflow:**
1. User uploads image to upload S3 bucket
2. S3 event notification triggers Lambda function
3. Lambda processes image using Pillow library
4. Processed variants stored in processed S3 bucket
5. CloudWatch logs capture execution details

**Components:**
- Source S3 bucket with event notifications
- Destination S3 bucket for processed images
- AWS Lambda function with Python 3.12 runtime
- Lambda Layer containing Pillow library
- IAM roles and policies for secure access
- CloudWatch Logs for monitoring

## Features

- Automated serverless image processing pipeline
- Multiple output formats generated per upload:
  - Compressed JPEG (quality 85)
  - Low-quality JPEG (quality 50)
  - WebP format for web optimization
  - PNG format
  - Thumbnail (150x150 pixels)
- S3 event-driven architecture
- Lambda Layer for efficient dependency management
- Server-side encryption for all S3 buckets
- Versioning enabled on both buckets
- Public access blocked by default
- CloudWatch logging with 7-day retention
- Unique bucket naming with random suffixes

## Prerequisites

- AWS CLI configured with appropriate credentials
- Terraform version 1.0 or higher
- Python 3.12 for local testing
- Pillow library layer ZIP file
- AWS account with Lambda, S3, and IAM permissions

## Project Structure

```
Image-Processing-with-Lambda-Terraform/
├── terraform/
│   ├── main.tf              # Complete infrastructure definition
│   ├── variables.tf         # Input variable declarations
│   ├── outputs.tf           # Output value definitions
│   ├── provider.tf          # AWS provider configuration
│   ├── pillow_layer.zip     # Pillow library Lambda Layer
│   └── lambda_function.zip  # Generated during deployment
├── lambda/
│   └── lambda_function.py   # Image processing logic
├── scripts/                 # Helper scripts
└── screenshots/             # Documentation images
```

## Lambda Function Details

The Lambda function performs the following operations:

1. Receives S3 event notification with uploaded image details
2. Downloads image from upload bucket
3. Processes image using Pillow library
4. Creates five variants with different formats and optimizations
5. Uploads processed images to processed bucket with organized naming
6. Logs operation details to CloudWatch

**Configuration:**
- Runtime: Python 3.12
- Memory: 1024 MB
- Timeout: 60 seconds
- Handler: lambda_function.lambda_handler

## Image Processing Output

For each uploaded image (e.g., `photo.jpg`), the function generates:

- `photo_compressed.jpg` - JPEG at 85% quality
- `photo_low_quality.jpg` - JPEG at 50% quality
- `photo_converted.webp` - WebP format
- `photo_converted.png` - PNG format
- `photo_thumbnail.jpg` - 150x150 thumbnail

## S3 Bucket Configuration

**Upload Bucket:**
- Receives original images
- Triggers Lambda on object creation
- Versioning enabled
- Server-side encryption (AES-256)
- Public access blocked

**Processed Bucket:**
- Stores Lambda-generated variants
- Versioning enabled
- Server-side encryption (AES-256)
- Public access blocked

Both buckets use globally unique names with random suffixes.

## IAM Permissions

The Lambda execution role has the following permissions:

**CloudWatch Logs:**
- CreateLogGroup
- CreateLogStream
- PutLogEvents

**S3 Read (Upload Bucket):**
- GetObject
- GetObjectVersion

**S3 Write (Processed Bucket):**
- PutObject
- PutObjectAcl

## Deployment

1. Prepare the Pillow Lambda Layer:
   ```bash
   cd scripts
   ./build_pillow_layer.sh
   ```

2. Navigate to the terraform directory:
   ```bash
   cd terraform
   ```

3. Initialize Terraform:
   ```bash
   terraform init
   ```

4. Review the planned infrastructure:
   ```bash
   terraform plan
   ```

5. Deploy the infrastructure:
   ```bash
   terraform apply
   ```

6. Note the bucket names from outputs

## Usage

1. Upload an image to the upload bucket:
   ```bash
   aws s3 cp image.jpg s3://<upload-bucket-name>/
   ```

2. Lambda function processes automatically

3. Check processed bucket for output variants:
   ```bash
   aws s3 ls s3://<processed-bucket-name>/
   ```

4. Download processed images:
   ```bash
   aws s3 cp s3://<processed-bucket-name>/ . --recursive
   ```

## Monitoring

View Lambda execution logs:

```bash
aws logs tail /aws/lambda/<function-name> --follow
```

The logs include:
- Image processing start and completion
- Generated variant details
- Execution duration and memory usage
- Any errors or exceptions

## Configuration Variables

Customize deployment by modifying `variables.tf`:

- `project_name` - Project identifier for resource naming
- `environment` - Environment tag (dev, staging, prod)
- `aws_region` - AWS region for deployment

## Outputs

After deployment, Terraform provides:

- Upload bucket name and ARN
- Processed bucket name and ARN
- Lambda function name and ARN
- Lambda function role ARN
- CloudWatch log group name

## Cost Optimization

- Lambda free tier: 1 million requests and 400,000 GB-seconds per month
- S3 free tier: 5GB storage, 20,000 GET requests, 2,000 PUT requests
- No charges when idle
- Pay only for actual usage

## Security Features

- IAM role with least privilege permissions
- S3 buckets with public access blocked
- Server-side encryption enabled
- Versioning for data protection
- No hardcoded credentials
- Environment variables for configuration

## Cleanup

Remove all infrastructure:

```bash
terraform destroy
```

Note: Buckets must be empty before deletion. Use `force_destroy = true` to automate this.

## Troubleshooting

**Lambda Not Triggering:**
- Verify S3 event notification configuration
- Check Lambda permissions allow S3 invocation
- Review CloudWatch logs for errors

**Processing Failures:**
- Confirm Pillow layer is correctly attached
- Verify memory and timeout settings are sufficient
- Check IAM role has required S3 permissions
- Review Lambda logs for specific error messages

**Image Quality Issues:**
- Adjust quality parameters in lambda_function.py
- Modify thumbnail dimensions as needed
- Add additional format conversions if required

## Use Cases

- Automatic image optimization for web applications
- Multi-format image conversion for cross-platform compatibility
- Thumbnail generation for galleries and listings
- Learning serverless architecture patterns
- Portfolio project demonstrating AWS Lambda and event-driven design

## Extension Ideas

- Add image resizing to multiple dimensions
- Implement watermarking functionality
- Add metadata extraction and tagging
- Configure SNS notifications for processing completion
- Implement error handling and retry logic
- Add support for additional image formats

## License

This project is provided as-is for educational and professional use.

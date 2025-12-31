# Static Website Hosting with AWS S3 and CloudFront

A production-ready Infrastructure as Code (IaC) project that deploys a static website using AWS S3 for storage and CloudFront for global content delivery. Built with Terraform to demonstrate cloud infrastructure automation and modern DevOps practices.

## Architecture Overview

This project implements a secure, scalable static website hosting solution using AWS managed services. The architecture follows AWS best practices for performance, security, and cost optimization.

### Key Components

- **Amazon S3**: Object storage for static website files with private access control
- **CloudFront**: Global CDN for low-latency content delivery with HTTPS support
- **Origin Access Control (OAC)**: Secure authentication between CloudFront and S3
- **Terraform**: Infrastructure as Code for reproducible deployments
- **Remote State Management**: S3 backend for collaborative infrastructure management

## Features

- **Secure by Default**: S3 bucket with all public access blocked, content served exclusively through CloudFront
- **HTTPS Enabled**: Automatic HTTP to HTTPS redirection for all traffic
- **Global Performance**: CloudFront edge locations provide low-latency access worldwide
- **Automated Deployment**: Complete infrastructure provisioned with single Terraform command
- **Content Type Detection**: Automatic MIME type assignment for proper browser rendering
- **State Management**: Remote state storage in S3 for team collaboration
- **Cost Optimized**: PriceClass_100 limits edge locations to North America and Europe

## Architecture Diagram

See [architecture.md](./architecture.md) for a detailed visual diagram and component descriptions of the infrastructure.

## Prerequisites

- AWS Account with appropriate IAM permissions
- AWS CLI configured with credentials
- Terraform >= 1.0
- S3 bucket for Terraform state (must be created manually)

### Required AWS Permissions

Your IAM user/role needs permissions for:
- S3 (bucket creation, object management, policy attachment)
- CloudFront (distribution creation and management)
- S3 backend access for state storage

## Project Structure

```
.
├── provider.tf          # Terraform and AWS provider configuration
├── variables.tf         # Input variable definitions
├── local.tf            # Local value computations
├── s3.tf               # S3 bucket, CloudFront, and resource definitions
├── output.tf           # Output values for deployed resources
├── static/             # Static website files directory
│   ├── index.html
│   ├── styles.css
│   └── script.js
└── README.md           # Project documentation
```

## Configuration

### Backend Configuration

The Terraform backend is configured to use S3 for remote state storage. Before deployment, ensure the backend bucket exists:

```bash
aws s3 mb s3://arh-s3-backend-static-website-with-cloudfront --region us-east-2
```

Backend configuration in `provider.tf`:
```hcl
backend "s3" {
  bucket = "arh-s3-backend-static-website-with-cloudfront"
  key    = "static-website-cloudfront/terraform.tfstate"
  region = "us-east-2"
}
```

### Customization

Modify `variables.tf` to customize the S3 bucket name:

```hcl
variable "bucket_name" {
  default = "your-unique-bucket-name"
}
```

## Deployment

### 1. Clone the Repository

```bash
git clone <repository-url>
cd Static-Website-with-S3-CloudFront
```

### 2. Initialize Terraform

```bash
terraform init
```

This downloads required providers and configures the S3 backend.

### 3. Review Planned Changes

```bash
terraform plan
```

Review the resources that will be created.

### 4. Deploy Infrastructure

```bash
terraform apply
```

Type `yes` when prompted to confirm deployment.

### 5. Access Your Website

After deployment completes (5-15 minutes for CloudFront), use the output URL:

```bash
terraform output website_url
```

## Outputs

The following values are available after deployment:

| Output | Description |
|--------|-------------|
| `website_url` | Complete HTTPS URL for accessing the website |
| `cloudfront_domain_name` | CloudFront distribution domain name |
| `cloudfront_distribution_id` | Distribution ID for cache invalidation operations |
| `s3_bucket_name` | S3 bucket name hosting the files |

## Updating Website Content

To update website files:

1. Modify files in the `static/` directory
2. Run `terraform apply` to upload changes
3. Invalidate CloudFront cache for immediate updates:

```bash
aws cloudfront create-invalidation \
  --distribution-id $(terraform output -raw cloudfront_distribution_id) \
  --paths "/*"
```

## Security Considerations

- **Private S3 Bucket**: All public access blocked at bucket level
- **Origin Access Control**: CloudFront uses OAC (modern replacement for OAI) for S3 authentication
- **HTTPS Only**: All HTTP requests automatically redirected to HTTPS
- **Principle of Least Privilege**: Bucket policy grants only necessary permissions to CloudFront
- **Geographic Restrictions**: Distribution limited to US, CA, GB, and DE

## Cost Optimization

- **PriceClass_100**: Uses only North America and Europe edge locations
- **S3 Standard**: Suitable for frequently accessed content
- **Default CloudFront Certificate**: No additional cost for SSL/TLS
- **Efficient Caching**: TTL settings reduce origin requests

## Cleanup

To destroy all resources and avoid ongoing charges:

```bash
terraform destroy
```

Note: This does not delete the S3 backend bucket containing Terraform state.

## Technical Highlights

### Infrastructure as Code
- Declarative configuration using Terraform HCL
- Version-controlled infrastructure changes
- Reproducible deployments across environments

### Cloud-Native Architecture
- Serverless design with no infrastructure to manage
- Auto-scaling through AWS managed services
- Pay-per-use pricing model

### DevOps Best Practices
- Remote state management for team collaboration
- Modular resource organization
- Comprehensive documentation and comments

## Next Steps

### Planned Enhancements

- **Custom Domain with Route 53**: Configure custom domain name with DNS management
- **SSL Certificate with ACM**: Add AWS Certificate Manager for custom domain HTTPS
- **CI/CD Pipeline**: Implement automated deployments on code changes
- **Multiple Environments**: Create dev, staging, and production environments
- **Advanced CloudFront Configurations**: Add custom error pages and security headers

## Troubleshooting

### CloudFront Returns 403 Forbidden
- Wait 5-15 minutes for distribution to fully deploy
- Verify OAC is correctly configured
- Check S3 bucket policy allows CloudFront access

### Terraform State Lock Error
- Ensure no other Terraform processes are running
- Check S3 backend bucket is accessible
- Consider adding DynamoDB table for state locking

### File Upload Issues
- Verify files exist in `static/` directory
- Check AWS credentials have S3 write permissions
- Review Terraform plan for file changes

## Author

This project demonstrates proficiency in:
- AWS cloud services (S3, CloudFront)
- Infrastructure as Code (Terraform)
- DevOps practices and automation
- Cloud security best practices
- Technical documentation

## License

This project is available for educational and portfolio purposes.

---

**Built with Terraform | Deployed on AWS**

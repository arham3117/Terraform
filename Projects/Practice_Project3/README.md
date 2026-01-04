# Static Website Hosting with S3 and Terraform

## Overview

This project demonstrates how to deploy a static website on AWS S3 using Terraform. It creates an S3 bucket configured for static website hosting, uploads HTML and CSS files, and configures public access policies to serve the website content directly from S3.

## Architecture

The infrastructure provisions the following AWS resources:

- S3 bucket configured for static website hosting
- Public access configuration for web serving
- Bucket policy allowing public read access
- S3 objects for HTML and CSS files
- Website configuration with index document

## Features

- Automated S3 bucket creation and configuration
- Static website hosting setup
- Public access policy for website availability
- Automatic HTML and CSS file upload
- Infrastructure as code for reproducible deployments
- Simple and cost-effective hosting solution

## Prerequisites

- AWS CLI configured with appropriate credentials
- Terraform version 1.0 or higher
- AWS account with S3 permissions
- HTML and CSS files for your website

## Project Structure

```
Practice_Project3/
├── s3.tf           # S3 bucket and object configurations
├── providers.tf    # AWS provider configuration
├── terraform.tf    # Terraform version requirements
├── outputs.tf      # Output definitions for website URL
├── index.html      # Website home page
└── style.css       # Website stylesheet
```

## S3 Bucket Configuration

The bucket is configured with the following settings:

**Public Access:**
- Public ACLs allowed
- Public policies allowed
- Public bucket access enabled

**Website Hosting:**
- Index document: index.html
- Direct URL access via S3 website endpoint

**Bucket Policy:**
- Allows public GetObject access
- Enables anyone to view website content

## Deployment

1. Navigate to the project directory
2. Ensure `index.html` and `style.css` exist in the directory
3. Initialize Terraform:
   ```bash
   terraform init
   ```
4. Review the planned infrastructure:
   ```bash
   terraform plan
   ```
5. Deploy the website:
   ```bash
   terraform apply
   ```
6. Access the website URL from Terraform outputs

## Accessing Your Website

After deployment, your website will be available at:

```
http://<bucket-name>.s3-website-<region>.amazonaws.com
```

The exact URL will be displayed in Terraform outputs.

## Updating Website Content

### Updating HTML/CSS Files

1. Modify `index.html` or `style.css` locally
2. Reapply Terraform configuration:
   ```bash
   terraform apply
   ```

Terraform will detect file changes and update S3 objects automatically.

### Adding New Files

1. Add new file resources to `s3.tf`:
   ```hcl
   resource "aws_s3_object" "new_file" {
     bucket       = aws_s3_bucket.my_webapp_s3.bucket
     source       = "./new-file.js"
     key          = "new-file.js"
     content_type = "application/javascript"
   }
   ```

2. Apply the changes:
   ```bash
   terraform apply
   ```

## Content Types

Ensure correct content types for proper browser rendering:

- HTML files: `text/html`
- CSS files: `text/css`
- JavaScript files: `application/javascript`
- Images (PNG): `image/png`
- Images (JPEG): `image/jpeg`

## Outputs

The project outputs the following information:

- S3 bucket name
- Website endpoint URL
- Bucket ARN
- Regional domain name

## Security Considerations

**Note:** This configuration allows public access to all bucket contents.

- Only use for truly public websites
- Do not store sensitive information in this bucket
- Consider using CloudFront for HTTPS support
- Implement bucket versioning for content recovery
- Enable server access logging for audit trails

## Cost Optimization

S3 static website hosting is cost-effective:

- S3 storage: ~$0.023 per GB per month
- Data transfer: First 1 GB/month free, then ~$0.09 per GB
- No server costs
- No compute charges
- Pay only for actual storage and data transfer

## Cleanup

To remove the website and all resources:

```bash
terraform destroy
```

Note: The bucket will be deleted along with all its contents.

## Limitations

- No HTTPS support (use CloudFront for SSL/TLS)
- No server-side processing
- Limited to static content only
- No built-in CDN (add CloudFront separately)

## Best Practices

- Use version control for website files
- Enable S3 versioning for content rollback
- Implement CloudFront for better performance
- Add Route 53 for custom domain names
- Use S3 lifecycle policies for cost management
- Monitor S3 costs and access patterns

## Enhancement Ideas

- Add CloudFront distribution for HTTPS and CDN
- Configure custom domain with Route 53
- Implement CI/CD pipeline for automatic deployments
- Add multiple pages and assets
- Enable S3 bucket versioning
- Add access logging and monitoring
- Implement error page configuration

## Common Issues

**Website Not Accessible:**
- Verify public access is enabled
- Check bucket policy allows GetObject
- Ensure website configuration is set
- Confirm files are uploaded correctly

**CSS Not Loading:**
- Verify content_type is set to "text/css"
- Check file path in HTML matches S3 key
- Ensure CSS file is uploaded to bucket

**403 Forbidden Error:**
- Review bucket policy syntax
- Confirm public access block settings
- Verify IAM permissions for Terraform user

## Use Cases

- Personal portfolio websites
- Landing pages
- Documentation sites
- Marketing campaign pages
- Simple web applications
- Learning AWS S3 website hosting
- Testing website designs

## Comparison with Other Hosting

**Advantages:**
- Very low cost
- Simple deployment
- No server management
- High availability by default
- Easy to version control

**Disadvantages:**
- No server-side processing
- No built-in HTTPS
- Limited to static content
- No database integration

## License

This project is provided as-is for educational and professional use.

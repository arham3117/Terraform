# Multi-Environment Infrastructure with Terraform

## Overview

This project demonstrates a scalable multi-environment infrastructure deployment using Terraform modules. It provisions separate development, staging, and production environments with EC2 instances, S3 buckets, and DynamoDB tables, each configured with environment-specific parameters.

## Architecture

The infrastructure creates the following AWS resources for each environment:

- EC2 instances with configurable counts and instance types
- S3 buckets for storage
- DynamoDB tables for data persistence
- VPC security groups with SSH, HTTP, and HTTPS access
- SSH key pairs for secure instance access

## Features

- Environment-based resource provisioning (dev, staging, prod)
- Reusable infrastructure module for consistency
- Environment-specific configurations:
  - Development: 1x t2.micro instance, 10GB storage
  - Staging: 1x t2.small instance, 10GB storage
  - Production: 2x t2.medium instances, 20GB storage
- Automated security group configuration
- Default VPC utilization
- Resource tagging for environment tracking

## Prerequisites

- AWS CLI configured with appropriate credentials
- Terraform version 1.0 or higher
- SSH public key file (`terra-key-ec2-Day2.pub`)
- AWS account with EC2, S3, and DynamoDB permissions

## Project Structure

```
Practice_Project1/
├── main.tf              # Root module with environment configurations
├── providers.tf         # AWS provider configuration
├── terraform.tf         # Terraform version requirements
├── terra-key-ec2-Day2.pub  # SSH public key
└── infra-app/           # Reusable infrastructure module
    ├── ec2.tf           # EC2, VPC, and security group resources
    ├── s3.tf            # S3 bucket configuration
    ├── dynamodb.tf      # DynamoDB table configuration
    └── variables.tf     # Module input variables
```

## Configuration

### Environment Specifications

**Development Environment:**
- 1 EC2 instance (t2.micro)
- 10GB root volume
- Environment tag: dev

**Staging Environment:**
- 1 EC2 instance (t2.small)
- 10GB root volume
- Environment tag: stg

**Production Environment:**
- 2 EC2 instances (t2.medium)
- 20GB root volume
- Environment tag: prod

### Security Groups

All environments include security groups with the following rules:

**Inbound:**
- Port 22 (SSH)
- Port 80 (HTTP)
- Port 443 (HTTPS)

**Outbound:**
- All traffic allowed

## Deployment

1. Navigate to the project directory
2. Ensure your SSH public key exists at `terra-key-ec2-Day2.pub`
3. Initialize Terraform:
   ```bash
   terraform init
   ```
4. Review the planned infrastructure:
   ```bash
   terraform plan
   ```
5. Deploy all environments:
   ```bash
   terraform apply
   ```

## Module Usage

The infrastructure module can be called with the following parameters:

```hcl
module "environment-infra" {
  source         = "./infra-app"
  env            = "environment-name"
  bucket_name    = "bucket-name"
  instance_count = 1
  instance_type  = "instance-type"
  ec2_ami_id     = "ami-id"
  hash_key       = "key-name"
}
```

## Outputs

Each environment module outputs the following information:

- EC2 instance IDs and public IP addresses
- S3 bucket names and ARNs
- DynamoDB table names
- Security group IDs

## Resource Management

All resources are tagged with:
- Name: Environment-specific resource identifier
- Environment: dev, stg, or prod

## Cleanup

To remove all resources:

```bash
terraform destroy
```

## Best Practices Implemented

- Modular infrastructure design for reusability
- Environment-specific resource sizing
- Conditional logic for storage allocation
- Consistent naming conventions
- Comprehensive resource tagging
- Security group isolation per environment

## Use Cases

- Multi-environment application deployment
- Testing infrastructure changes across environments
- Learning Terraform module development
- Demonstrating infrastructure as code practices

## License

This project is provided as-is for educational and professional use.

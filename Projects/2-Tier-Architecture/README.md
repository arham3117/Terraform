# 2-Tier Web Application Architecture with RDS

## Overview

This project implements a production-ready 2-tier web application architecture on AWS using Terraform. It provisions a complete infrastructure with a Flask web application running on EC2 in the public tier and a managed MySQL database in the private tier, following AWS best practices for security and high availability.

## Architecture

The infrastructure consists of the following components:

**Web Tier (Public):**
- EC2 instance running Flask application
- Public subnet with internet gateway access
- Security group allowing HTTP/HTTPS traffic

**Database Tier (Private):**
- RDS MySQL instance in private subnets
- Multi-AZ subnet configuration for high availability
- Security group restricting access to web tier only

**Supporting Services:**
- AWS Secrets Manager for secure password management
- VPC with public and private subnets across availability zones
- Route tables and internet gateway for network routing
- Security groups for network isolation

## Features

- Modular infrastructure design with separate modules for each component
- Automated database password generation and secure storage
- VPC with public and private subnet architecture
- Network isolation between web and database tiers
- Automated EC2 user data script for Flask application deployment
- RDS automated backups and maintenance windows
- Environment-based resource tagging
- Free tier eligible default configuration

## Prerequisites

- AWS CLI configured with appropriate credentials
- Terraform version 1.0 or higher
- AWS account with VPC, EC2, RDS, and Secrets Manager permissions
- Basic understanding of networking concepts

## Project Structure

```
2-Tier-Architecture/
├── main.tf                    # Root module orchestrating all components
├── providers.tf               # AWS provider configuration
├── variables.tf               # Input variable definitions
├── outputs.tf                 # Output value definitions
├── terraform.tfvars.example   # Example variable values
├── screenshots/               # Documentation images
└── modules/
    ├── vpc/                   # VPC, subnets, and routing
    ├── security_groups/       # Security group definitions
    ├── ec2/                   # Web server configuration
    ├── rds/                   # Database instance
    └── secrets/               # Secrets Manager integration
```

## Module Descriptions

**VPC Module:**
- Creates VPC with configurable CIDR block
- Provisions public subnet for web tier
- Creates private subnets for database tier
- Configures internet gateway and route tables

**Security Groups Module:**
- Web security group with HTTP/HTTPS access
- Database security group with MySQL access restricted to web tier
- Egress rules for outbound connectivity

**EC2 Module:**
- Launches web server instance with Flask application
- Configures user data script for automated application setup
- Associates with web security group and public subnet
- Retrieves database credentials from environment variables

**RDS Module:**
- Provisions managed MySQL database instance
- Configures automated backups with 7-day retention
- Sets up subnet group across multiple availability zones
- Integrates with Secrets Manager for password management

**Secrets Module:**
- Generates secure random password for database
- Stores credentials in AWS Secrets Manager
- Provides secure access to database password

## Configuration

### Default Variables

The project includes sensible defaults for quick deployment:

- Region: us-east-1
- VPC CIDR: 10.0.0.0/16
- EC2 Instance: t2.micro (free tier eligible)
- RDS Instance: db.t3.micro (free tier eligible)
- Database Engine: MySQL 8.0
- Storage: 10GB

### Customization

To customize the deployment, create a `terraform.tfvars` file:

```hcl
project_name      = "your-project-name"
environment       = "dev"
aws_region        = "us-east-1"
vpc_cidr          = "10.0.0.0/16"
ec2_instance_type = "t2.micro"
db_instance_class = "db.t3.micro"
```

## Deployment

1. Clone the repository and navigate to the project directory
2. Review and customize variables in `terraform.tfvars`
3. Initialize Terraform:
   ```bash
   terraform init
   ```
4. Review the infrastructure plan:
   ```bash
   terraform plan
   ```
5. Deploy the infrastructure:
   ```bash
   terraform apply
   ```
6. Note the outputs including EC2 public IP and RDS endpoint

## Accessing the Application

After successful deployment:

1. Retrieve the EC2 public IP from Terraform outputs
2. Access the Flask application at `http://<ec2-public-ip>`
3. The application connects to the RDS database automatically
4. Database credentials are securely managed via Secrets Manager

## Security Features

- Database credentials stored in AWS Secrets Manager
- Database isolated in private subnets with no internet access
- Security groups implementing least privilege access
- VPC network isolation between tiers
- Automated password generation
- Encrypted database storage (AES-256)
- Secure parameter passing via environment variables

## Outputs

The deployment provides the following outputs:

- VPC ID and subnet IDs
- EC2 instance public IP address
- RDS endpoint and connection information
- Security group IDs
- Database name and username

## Cleanup

To remove all infrastructure:

```bash
terraform destroy
```

Note: The Secrets Manager secret will be scheduled for deletion with a recovery window.

## Best Practices Implemented

- Infrastructure as code with modular design
- Network segmentation with public/private subnets
- Secure credential management
- Multi-AZ database configuration support
- Resource tagging for organization and cost tracking
- Automated application deployment via user data
- Version-controlled infrastructure configuration

## Cost Optimization

- Free tier eligible instance types by default
- Minimal storage allocation (10GB)
- Single-AZ deployment for development
- Pay-as-you-go pricing model

## Troubleshooting

**Database Connection Issues:**
- Verify security group rules allow traffic from web tier
- Check RDS endpoint in outputs matches application configuration
- Confirm Secrets Manager contains valid credentials

**EC2 Access Issues:**
- Ensure security group allows inbound HTTP traffic
- Verify EC2 instance is in public subnet with internet gateway
- Check application logs via EC2 instance connect or SSH

## Use Cases

- Learning AWS 2-tier architecture patterns
- Deploying web applications with database backends
- Demonstrating Terraform modular design
- Testing application deployment automation
- Portfolio project for cloud engineering roles

## License

This project is provided as-is for educational and professional use.

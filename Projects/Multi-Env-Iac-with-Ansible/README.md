# Multi-Environment Infrastructure as Code with Terraform & Ansible

A comprehensive Infrastructure as Code (IaC) solution that deploys and manages AWS infrastructure across multiple environments (Development, Staging, Production) using Terraform and Ansible.

![Infrastructure](https://img.shields.io/badge/Infrastructure-AWS-orange)
![Terraform](https://img.shields.io/badge/Terraform-1.0+-blue)
![Ansible](https://img.shields.io/badge/Ansible-2.9+-red)
![License](https://img.shields.io/badge/License-MIT-green)

## 🏗️ Architecture Overview

This project implements a scalable, multi-environment infrastructure with the following components:

### Infrastructure Components
- **EC2 Instances**: Scalable compute resources across environments
- **S3 Buckets**: Object storage for each environment
- **DynamoDB Tables**: NoSQL database for application data
- **VPC Security Groups**: Network security and access control
- **SSH Key Pairs**: Secure instance access

### Environment Specifications

| Environment | EC2 Instances | Instance Type | Storage | Use Case |
|-------------|---------------|---------------|---------|----------|
| **Development** | 2x t2.micro | 1 vCPU, 1GB RAM | 10GB | Testing & Development |
| **Staging** | 2x t2.small | 1 vCPU, 2GB RAM | 15GB | Pre-production Testing |
| **Production** | 3x t2.medium | 2 vCPUs, 4GB RAM | 20GB | Live Environment |

## 📋 Prerequisites

Before getting started, ensure you have the following installed and configured:

### Required Tools
- **Terraform** >= 1.0
- **Ansible** >= 2.9
- **AWS CLI** >= 2.0
- **Git**
- **jq** (for JSON parsing)

### AWS Requirements
- AWS Account with appropriate permissions
- AWS CLI configured with credentials
- IAM permissions for EC2, S3, DynamoDB, and VPC resources

### Installation Commands
```bash
# Install Terraform (macOS)
brew install terraform

# Install Ansible (macOS)
brew install ansible

# Install AWS CLI (macOS)
brew install awscli

# Install jq
brew install jq

# Configure AWS CLI
aws configure
```

## 🚀 Quick Start

### 1. Clone the Repository
```bash
git clone https://github.com/arham3117/Terraform.git
cd Terraform/Projects/Multi-Env-Iac-with-Ansible
```

### 2. Set Up SSH Key Pair
```bash
cd terraform
ssh-keygen -t rsa -b 4096 -f your-terra-key -N ""
```

### 3. Initialize and Deploy Infrastructure
```bash
# Initialize Terraform
terraform init

# Review the deployment plan
terraform plan

# Deploy infrastructure
terraform apply

# Confirm with 'yes' when prompted
```

### 4. Update Ansible Inventories
```bash
# Run the automated inventory update script
./update-inventory.sh
```

### 5. Configure Private Key Path
Update the inventory files with your actual private key path:
```bash
# In ansible/inventories/dev, stg, and prd files
# Replace: ansible_ssh_private_key_file=path_to_your_private_key
# With: ansible_ssh_private_key_file=../../terraform/your-terra-key
```

### 6. Deploy Applications with Ansible
```bash
cd ansible
# Test connectivity
ansible -i inventories/dev servers -m ping

# Deploy Nginx to development environment
ansible-playbook -i inventories/dev playbooks/install_nginx.yml
```

## 📁 Project Structure

```
Multi-Env-Iac-with-Ansible/
├── terraform/                          # Terraform infrastructure code
│   ├── infrastructure/                 # Reusable infrastructure module
│   │   ├── ec2.tf                     # EC2 instances and security groups
│   │   ├── s3_bucket.tf               # S3 bucket configuration
│   │   ├── dynamo_db.tf               # DynamoDB table setup
│   │   ├── variables.tf               # Input variables
│   │   └── outputs.tf                 # Output values
│   ├── main.tf                        # Main configuration file
│   ├── provider.tf                    # AWS provider configuration
│   ├── your-terra-key                 # Private SSH key (auto-generated)
│   └── your-terra-key.pub             # Public SSH key (auto-generated)
├── ansible/                           # Ansible automation code
│   ├── inventories/                   # Environment-specific inventories
│   │   ├── dev                        # Development inventory
│   │   ├── stg                        # Staging inventory
│   │   ├── prd                        # Production inventory
│   │   └── backup/                    # Inventory backups (auto-created)
│   └── playbooks/                     # Ansible playbooks and roles
│       ├── install_nginx.yml          # Nginx installation playbook
│       └── roles/nginx-role/          # Nginx role with custom landing page
├── update-inventory.sh                # Automated inventory update script
└── README.md                          # This file
```

## 🔧 Usage

### Automated Workflow
The typical workflow for infrastructure management:

```bash
# 1. Deploy/Update Infrastructure
cd terraform && terraform apply && cd ..

# 2. Update Ansible Inventories (automatically extracts new IPs)
./update-inventory.sh

# 3. Deploy Applications
cd ansible
ansible-playbook -i inventories/dev playbooks/install_nginx.yml
ansible-playbook -i inventories/stg playbooks/install_nginx.yml
ansible-playbook -i inventories/prd playbooks/install_nginx.yml
```

### Individual Environment Management

#### Development Environment
```bash
# Deploy only dev infrastructure (if using targeted apply)
terraform apply -target=module.dev-infra

# Deploy to dev environment
ansible-playbook -i inventories/dev playbooks/install_nginx.yml
```

#### Staging Environment
```bash
terraform apply -target=module.stg-infra
ansible-playbook -i inventories/stg playbooks/install_nginx.yml
```

#### Production Environment
```bash
terraform apply -target=module.prd-infra
ansible-playbook -i inventories/prd playbooks/install_nginx.yml
```

## 🛠️ Key Features

### 🔄 Automated Inventory Management
The `update-inventory.sh` script automatically:
- Extracts public IP addresses from Terraform state
- Updates Ansible inventory files for all environments
- Creates timestamped backups (keeps last 2 per environment)
- Provides colored output for better visibility

### 🎨 Custom Landing Page
The project includes a beautiful, dark-themed landing page featuring:
- Modern glassmorphism design
- Animated particles background
- Environment-specific information display
- Responsive design for all devices
- Infrastructure statistics overview

### 🔐 Security Best Practices
- Comprehensive `.gitignore` prevents sensitive data exposure
- SSH key pairs for secure instance access
- Security groups with minimal required permissions
- Encrypted storage options available
- Environment-specific resource tagging

### 📊 Environment Scaling
- Automatically scales resources based on environment needs
- Cost-optimized instance types for each environment
- Flexible storage allocation
- Easy environment duplication

## 🔍 Monitoring and Maintenance

### Viewing Deployed Resources
```bash
# View Terraform-managed resources
terraform state list

# Get output values (IP addresses, resource IDs)
terraform output

# Check infrastructure status
terraform plan
```

### Ansible Operations
```bash
# Test connectivity to all environments
ansible -i inventories/dev servers -m ping
ansible -i inventories/stg servers -m ping
ansible -i inventories/prd servers -m ping

# Run ad-hoc commands
ansible -i inventories/dev servers -a "uptime"
ansible -i inventories/prd servers -a "df -h"
```

## 🚨 Troubleshooting

### Common Issues and Solutions

#### SSH Connection Issues
```bash
# Check SSH key permissions
chmod 400 terraform/your-terra-key

# Test direct SSH connection
ssh -i terraform/your-terra-key ubuntu@<instance-ip>

# Skip host key checking (for new instances)
export ANSIBLE_HOST_KEY_CHECKING=False
```

#### Terraform State Issues
```bash
# Refresh state
terraform refresh

# Import existing resources (if needed)
terraform import aws_instance.example i-1234567890abcdef0

# Force unlock state (if locked)
terraform force-unlock <lock-id>
```

#### Ansible Playbook Failures
```bash
# Run with verbose output
ansible-playbook -i inventories/dev playbooks/install_nginx.yml -vvv

# Check syntax
ansible-playbook --syntax-check playbooks/install_nginx.yml

# Dry run
ansible-playbook -i inventories/dev playbooks/install_nginx.yml --check
```

#### Inventory Update Script Issues
```bash
# Check if Terraform state exists
ls -la terraform/terraform.tfstate

# Manually check outputs
cd terraform && terraform output

# Verify jq installation
which jq || brew install jq
```

### Error Messages and Solutions

| Error | Solution |
|-------|----------|
| "No inventory was parsed" | Check inventory file path and format |
| "Permission denied (publickey)" | Verify SSH key permissions and path |
| "terraform.tfstate not found" | Run `terraform apply` first |
| "Module not found" | Run `terraform init` in the terraform directory |

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📞 Support

If you encounter any issues or have questions:

1. Check the troubleshooting section above
2. Review existing GitHub issues
3. Create a new issue with detailed information
4. Include relevant log outputs and error messages

## 🔄 Version History

- **v1.2** - Added automated inventory management and custom landing page
- **v1.1** - Security improvements and comprehensive documentation
- **v1.0** - Initial multi-environment infrastructure implementation

---

**Happy Infrastructure Coding!** 🚀

Made with ❤️ using Terraform and Ansible
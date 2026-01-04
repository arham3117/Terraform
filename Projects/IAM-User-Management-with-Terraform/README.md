# IAM User Management with Terraform

## Overview

This project automates the provisioning and management of AWS IAM users using Terraform. It creates IAM users from a CSV file, configures login profiles with secure passwords, assigns users to groups, and applies appropriate tags for organizational tracking.

## Architecture

The infrastructure provisions the following AWS resources:

- IAM Users with custom naming convention
- IAM User Login Profiles with password management
- IAM Groups for role-based access control
- User-to-group associations
- Resource tagging for department and job title tracking

## Features

- Automated IAM user creation from CSV data source
- Dynamic username generation based on first and last names
- Forced password reset on first login for security
- Department and job title tagging
- Group-based permission management
- Lifecycle management to prevent accidental password changes

## Prerequisites

- AWS CLI configured with appropriate credentials
- Terraform version 1.0 or higher
- AWS account with IAM administrative permissions
- CSV file containing user information (first_name, last_name, department, job_title)

## Project Structure

```
IAM-User-Management-with-Terraform/
├── data.tf           # Data sources and lookups
├── groups.tf         # IAM group definitions and associations
├── iam.tf            # IAM user and login profile resources
├── local.tf          # Local values and CSV parsing
├── outputs.tf        # Output values for created resources
├── provider.tf       # AWS provider configuration
├── variables.tf      # Input variable definitions
├── users.csv         # User data source file
└── screenshots/      # Documentation images
```

## Configuration

### Input Variables

The project uses the following key variables:

- AWS region configuration
- User data file path
- Group definitions
- Tagging requirements

### User Data Format

The `users.csv` file should contain the following columns:

- first_name
- last_name
- department
- job_title

## Deployment

1. Clone the repository and navigate to the project directory
2. Update `users.csv` with your user information
3. Configure AWS credentials
4. Initialize Terraform:
   ```bash
   terraform init
   ```
5. Review the planned changes:
   ```bash
   terraform plan
   ```
6. Apply the configuration:
   ```bash
   terraform apply
   ```

## Outputs

The project outputs the following information:

- Created IAM usernames
- User ARNs
- Group memberships
- Login profile status

## Security Features

- Password reset required on first login
- Lifecycle rules to prevent password modification drift
- Path-based user organization
- Group-based access control
- Comprehensive resource tagging

## Cleanup

To remove all created resources:

```bash
terraform destroy
```

## Best Practices

- Review the IAM users and groups before applying changes
- Store the Terraform state file securely
- Use separate CSV files for different environments
- Regularly audit user access and group memberships
- Implement MFA for privileged users separately

## License

This project is provided as-is for educational and professional use.

# AWS VPC Peering - Cross-Region Infrastructure

A comprehensive Terraform configuration for setting up cross-region AWS VPC peering between us-east-1 and us-west-2, complete with EC2 instances for connectivity testing.

## Architecture Overview

![VPC Peering Architecture](<screenshots/Screenshot 2026-01-01 at 5.14.01 PM.png>)

This infrastructure demonstrates a production-ready cross-region VPC peering setup that enables private network communication between two geographically separated VPCs.

## Detailed Architecture

![Detailed Architecture Diagram](<screenshots/Screenshot 2026-01-01 at 5.51.27 PM.png>)

The architecture consists of:
- **Primary VPC** (us-east-1): 10.0.0.0/16 CIDR block
- **Secondary VPC** (us-west-2): 10.1.0.0/16 CIDR block
- VPC Peering Connection enabling bidirectional communication
- Internet Gateways for external connectivity
- Route tables configured for both internet and cross-VPC traffic
- Security groups with appropriate ingress/egress rules
- EC2 instances running Apache web servers for testing

## Features

- Cross-region VPC peering between AWS regions
- Automated EC2 instance provisioning with Apache web server
- Dynamic AMI selection using data sources
- Comprehensive security group configuration
- Public IP assignment for SSH access
- Bidirectional routing between VPCs
- Infrastructure as Code using Terraform
- Remote state management with S3 backend

## Prerequisites

- Terraform >= 1.0
- AWS CLI configured with appropriate credentials
- AWS account with permissions to create VPCs, EC2 instances, and peering connections
- SSH key pairs created in both regions:
  - `vpc-peering-east` in us-east-1
  - `vpc-peering-west` in us-west-2

## Project Structure

```
.
├── provider.tf      # Terraform and AWS provider configuration
├── variables.tf     # Input variable definitions
├── data.tf          # Data sources for AMIs and availability zones
├── locals.tf        # Local values for user data scripts
├── vpc.tf           # Main infrastructure resources
├── outputs.tf       # Output values
└── README.md        # Project documentation
```

## Infrastructure Components

### 1. Virtual Private Clouds (VPCs)

Two VPCs with non-overlapping CIDR blocks:
- Primary VPC (us-east-1): 10.0.0.0/16
- Secondary VPC (us-west-2): 10.1.0.0/16

Both VPCs have DNS support and DNS hostnames enabled for proper instance communication.

### 2. Subnets

One public subnet per VPC, utilizing the entire VPC CIDR range and deployed in the first available availability zone.

### 3. Internet Gateways

Each VPC has its own internet gateway, providing:
- Outbound internet access for instances
- Inbound SSH connectivity

### 4. Route Tables

Configured with:
- Default route (0.0.0.0/0) to internet gateway
- VPC peering routes for cross-region communication
  - Primary → Secondary: Routes 10.1.0.0/16 via peering connection
  - Secondary → Primary: Routes 10.0.0.0/16 via peering connection

### 5. VPC Peering Connection

Cross-region peering connection enabling private network communication:
- Requester: Primary VPC (us-east-1)
- Accepter: Secondary VPC (us-west-2)
- Status: Active

**VPC Peering Connections in AWS Console:**

![VPC Peering Connection - Primary Region](<screenshots/Screenshot 2026-01-01 at 5.14.37 PM.png>)

### 6. Security Groups

Configured to allow:
- SSH access (port 22) from anywhere
- ICMP (ping) from peer VPC
- All TCP traffic from peer VPC
- All outbound traffic

### 7. EC2 Instances

One t2.micro instance per VPC running Ubuntu 24.04 LTS with:
- Apache web server installed via user data
- Public IP addresses for SSH access
- Custom web pages displaying instance information

**EC2 Instances in Both Regions:**

![EC2 Instances Running](<screenshots/Screenshot 2026-01-01 at 5.15.10 PM.png>)

## Deployment Instructions

### Step 1: Create SSH Key Pairs

Create SSH key pairs in both regions:

```bash
# Create key pair for us-east-1
aws ec2 create-key-pair \
  --key-name vpc-peering-east \
  --region us-east-1 \
  --query 'KeyMaterial' \
  --output text > vpc-peering-east.pem

# Create key pair for us-west-2
aws ec2 create-key-pair \
  --key-name vpc-peering-west \
  --region us-west-2 \
  --query 'KeyMaterial' \
  --output text > vpc-peering-west.pem

# Set appropriate permissions
chmod 400 vpc-peering-east.pem
chmod 400 vpc-peering-west.pem
```

### Step 2: Initialize Terraform

```bash
terraform init
```

### Step 3: Review Infrastructure Plan

```bash
terraform plan
```

### Step 4: Deploy Infrastructure

```bash
terraform apply
```

Review the proposed changes and type `yes` to confirm.

### Step 5: Verify Deployment

After successful deployment, Terraform will display output values including:
- VPC IDs
- Instance IDs and IP addresses
- SSH connection commands
- VPC peering connection status

**Route Tables Configuration:**

![Route Tables in Both Regions](<screenshots/Screenshot 2026-01-01 at 5.16.24 PM.png>)

**Subnets Configuration:**

![Subnets in Both Regions](<screenshots/Screenshot 2026-01-01 at 5.16.41 PM.png>)

## Testing VPC Peering Connectivity

### SSH Access

Connect to instances using the provided SSH commands from Terraform outputs:

```bash
# Connect to primary instance
ssh -i vpc-peering-east.pem ubuntu@<primary-public-ip>

# Connect to secondary instance
ssh -i vpc-peering-west.pem ubuntu@<secondary-public-ip>
```

### Ping Test

From the primary instance, ping the secondary instance's private IP:

```bash
ping <secondary-private-ip>
```

**Successful Ping Test Between VPCs:**

![Ping Test Results](<screenshots/Screenshot 2026-01-01 at 5.29.29 PM.png>)

The screenshot shows successful ping communication between instances in different regions, confirming the VPC peering connection is working correctly.

### Web Server Test

Test Apache connectivity through the VPC peering connection:

```bash
# From primary instance
curl <secondary-private-ip>

# From secondary instance
curl <primary-private-ip>
```

**Successful HTTP Communication Through VPC Peering:**

![Web Server Connectivity Test](<screenshots/Screenshot 2026-01-01 at 5.30.21 PM.png>)

The screenshot demonstrates successful HTTP requests between instances across the VPC peering connection. Each instance can access the Apache web server running on the other instance using private IP addresses, confirming end-to-end connectivity.

## Configuration Variables

| Variable | Description | Default | Required |
|----------|-------------|---------|----------|
| `environment` | Environment name for resource tagging | `dev` | No |
| `primary` | AWS region for primary VPC | `us-east-1` | No |
| `secondary` | AWS region for secondary VPC | `us-west-2` | No |
| `primary_vpc_cidr` | CIDR block for primary VPC | `10.0.0.0/16` | No |
| `secondary_vpc_cidr` | CIDR block for secondary VPC | `10.1.0.0/16` | No |
| `instance_type` | EC2 instance type | `t2.micro` | No |
| `primary_key_name` | SSH key pair name in us-east-1 | `vpc-peering-east` | No |
| `secondary_key_name` | SSH key pair name in us-west-2 | `vpc-peering-west` | No |

## Outputs

The following outputs are available after deployment:

### VPC Information
- `primary_vpc_id` - Primary VPC identifier
- `secondary_vpc_id` - Secondary VPC identifier

### VPC Peering Information
- `vpc_peering_connection_id` - Peering connection identifier
- `vpc_peering_status` - Current status of peering connection

### Instance Information
- `primary_instance_id` - Primary EC2 instance identifier
- `primary_instance_public_ip` - Public IP for SSH access
- `primary_instance_private_ip` - Private IP for VPC communication
- `secondary_instance_id` - Secondary EC2 instance identifier
- `secondary_instance_public_ip` - Public IP for SSH access
- `secondary_instance_private_ip` - Private IP for VPC communication

### Helper Commands
- `ssh_command_primary` - Ready-to-use SSH command for primary instance
- `ssh_command_secondary` - Ready-to-use SSH command for secondary instance
- `test_connectivity_from_primary` - Commands to test connectivity from primary
- `test_connectivity_from_secondary` - Commands to test connectivity from secondary

## Resource Cleanup

To destroy all created resources:

```bash
terraform destroy
```

Review the resources to be destroyed and type `yes` to confirm.

**Warning:** This will permanently delete all resources created by this Terraform configuration.

## Security Considerations

### Current Configuration (Development/Testing)

- SSH access is allowed from any IP address (0.0.0.0/0)
- Suitable for development and testing environments

### Production Recommendations

1. **Restrict SSH Access**: Limit SSH access to specific IP addresses or ranges:
   ```hcl
   cidr_blocks = ["your-office-ip/32"]
   ```

2. **Enable VPC Flow Logs**: Monitor network traffic for security analysis

3. **Implement Network ACLs**: Add an additional layer of network security

4. **Use AWS Systems Manager Session Manager**: Eliminate the need for SSH key management

5. **Enable Encryption**: Use encrypted EBS volumes for instances

6. **Implement Least Privilege**: Review and restrict security group rules to only necessary ports and protocols

## Cost Estimation

Estimated monthly costs (as of 2026):

- **VPC Peering**: $0 (no charge for VPC peering)
- **Data Transfer**: ~$0.02 per GB (cross-region data transfer)
- **EC2 Instances**: 2 x t2.micro instances (may be free tier eligible)
- **S3 Backend**: Minimal cost for state file storage

**Note:** Actual costs may vary based on usage. Always check current AWS pricing.

## Troubleshooting

### Issue: Key pair not found

**Solution**: Ensure SSH key pairs are created in the correct regions before running `terraform apply`.

### Issue: Instance has no public IP

**Solution**: Verify that `associate_public_ip_address = true` is set in the instance configuration.

### Issue: Cannot ping between instances

**Possible causes:**
1. Security groups not properly configured
2. VPC peering connection not active
3. Route tables missing peering routes

**Solution**: Verify security group rules allow ICMP and check peering connection status.

### Issue: Cannot access Apache web server

**Solution**: Ensure security groups allow TCP traffic from the peer VPC's CIDR block.

## License

This project is provided as-is for educational and demonstration purposes.

## Author

Infrastructure provisioned using Terraform and AWS best practices.

## Additional Resources

- [AWS VPC Peering Documentation](https://docs.aws.amazon.com/vpc/latest/peering/)
- [Terraform AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [AWS VPC Best Practices](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-security-best-practices.html)

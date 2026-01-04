# ============================================================================
# Output Values
# ============================================================================
# This file defines output values that are displayed after terraform apply
# These outputs provide important information about created resources

# ============================================================================
# VPC Outputs
# ============================================================================

output "primary_vpc_id" {
  description = "ID of the primary VPC in us-east-1"
  value       = aws_vpc.primary_vpc.id
}

output "secondary_vpc_id" {
  description = "ID of the secondary VPC in us-west-2"
  value       = aws_vpc.secondary_vpc.id
}

# ============================================================================
# VPC Peering Connection Outputs
# ============================================================================

output "vpc_peering_connection_id" {
  description = "ID of the VPC peering connection"
  value       = aws_vpc_peering_connection.primary_to_secondary.id
}

output "vpc_peering_status" {
  description = "Status of the VPC peering connection"
  value       = aws_vpc_peering_connection.primary_to_secondary.accept_status
}

# ============================================================================
# EC2 Instance Outputs - Primary VPC
# ============================================================================

output "primary_instance_id" {
  description = "ID of the EC2 instance in primary VPC"
  value       = aws_instance.primary_instance.id
}

output "primary_instance_public_ip" {
  description = "Public IP address of the primary instance (for SSH access)"
  value       = aws_instance.primary_instance.public_ip
}

output "primary_instance_private_ip" {
  description = "Private IP address of the primary instance (for VPC peering communication)"
  value       = aws_instance.primary_instance.private_ip
}

# ============================================================================
# EC2 Instance Outputs - Secondary VPC
# ============================================================================

output "secondary_instance_id" {
  description = "ID of the EC2 instance in secondary VPC"
  value       = aws_instance.secondary_instance.id
}

output "secondary_instance_public_ip" {
  description = "Public IP address of the secondary instance (for SSH access)"
  value       = aws_instance.secondary_instance.public_ip
}

output "secondary_instance_private_ip" {
  description = "Private IP address of the secondary instance (for VPC peering communication)"
  value       = aws_instance.secondary_instance.private_ip
}

# ============================================================================
# SSH Connection Information
# ============================================================================

output "ssh_command_primary" {
  description = "SSH command to connect to primary instance"
  value       = "ssh -i vpc-peering-east.pem ubuntu@${aws_instance.primary_instance.public_ip}"
}

output "ssh_command_secondary" {
  description = "SSH command to connect to secondary instance"
  value       = "ssh -i vpc-peering-west.pem ubuntu@${aws_instance.secondary_instance.public_ip}"
}

# ============================================================================
# Testing Commands
# ============================================================================

output "test_connectivity_from_primary" {
  description = "Command to test VPC peering from primary to secondary"
  value       = "From primary instance, run: ping ${aws_instance.secondary_instance.private_ip} or curl ${aws_instance.secondary_instance.private_ip}"
}

output "test_connectivity_from_secondary" {
  description = "Command to test VPC peering from secondary to primary"
  value       = "From secondary instance, run: ping ${aws_instance.primary_instance.private_ip} or curl ${aws_instance.primary_instance.private_ip}"
}

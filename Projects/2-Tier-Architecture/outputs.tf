# ==============================================================================
# Day 22 - RDS Database Mini Project
# Output Values
# ==============================================================================
# This file exports important resource attributes including VPC identifiers,
# web server access information, database endpoints, and application URLs
# ==============================================================================

# ------------------------------------------------------------------------------
# VPC Network Outputs
# ------------------------------------------------------------------------------
output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

# ------------------------------------------------------------------------------
# EC2 Web Server Outputs
# ------------------------------------------------------------------------------
output "web_server_public_ip" {
  description = "Public IP address of the web server"
  value       = module.ec2.public_ip
}

output "web_server_public_dns" {
  description = "Public DNS of the web server"
  value       = module.ec2.public_dns
}

output "application_url" {
  description = "URL to access the Flask web application running on EC2"
  value       = "http://${module.ec2.public_ip}"
}

# ------------------------------------------------------------------------------
# RDS Database Outputs
# ------------------------------------------------------------------------------
output "rds_endpoint" {
  description = "Connection endpoint for the RDS MySQL instance (hostname:port)"
  value       = module.rds.db_endpoint
}

output "rds_port" {
  description = "Port number for MySQL database connections (default: 3306)"
  value       = module.rds.db_port
}

output "database_name" {
  description = "Name of the database"
  value       = module.rds.db_name
}
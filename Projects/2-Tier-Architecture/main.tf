# ==============================================================================
# Secrets Management Module
# ==============================================================================
# Generates secure random password and stores database credentials in AWS
# Secrets Manager for secure access by application resources
module "secrets" {
  source = "./modules/secrets"

  project_name = var.project_name
  environment  = var.environment
  db_username  = var.db_username
}

# ==============================================================================
# VPC Networking Module
# ==============================================================================
# Creates Virtual Private Cloud with public subnet for web tier and private
# subnets for database tier, including internet gateway and route tables
module "vpc" {
  source = "./modules/vpc"

  project_name         = var.project_name
  environment          = var.environment
  aws_region           = var.aws_region
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidr   = var.public_subnet_cidr
  private_subnet_cidrs = var.private_subnet_cidrs
}

# ==============================================================================
# Security Groups Module
# ==============================================================================
# Configures security groups with firewall rules for web and database tiers,
# implementing network-level access controls and isolation
module "security_groups" {
  source = "./modules/security_groups"

  project_name = var.project_name
  environment  = var.environment
  vpc_id       = module.vpc.vpc_id
}

# ==============================================================================
# RDS Database Module
# ==============================================================================
# Provisions managed MySQL database instance in private subnets with automated
# backups, high availability options, and secure credential management
module "rds" {
  source = "./modules/rds"

  project_name         = var.project_name
  environment          = var.environment
  private_subnet_ids   = module.vpc.private_subnet_ids
  db_security_group_id = module.security_groups.db_sg_id
  db_name              = var.db_name
  db_username          = var.db_username
  db_password          = module.secrets.db_password
  instance_class       = var.db_instance_class
  allocated_storage    = var.db_allocated_storage
  engine_version       = var.db_engine_version
}

# ==============================================================================
# EC2 Web Server Module
# ==============================================================================
# Deploys EC2 instance in public subnet running Flask application with
# automated setup via user data script and database connectivity
module "ec2" {
  source = "./modules/ec2"

  project_name          = var.project_name
  environment           = var.environment
  instance_type         = var.ec2_instance_type
  public_subnet_id      = module.vpc.public_subnet_id
  web_security_group_id = module.security_groups.web_sg_id
  db_host               = module.rds.db_endpoint
  db_username           = var.db_username
  db_password           = module.secrets.db_password
  db_name               = var.db_name
}
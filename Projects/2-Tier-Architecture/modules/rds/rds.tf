# ==============================================================================
# RDS Module - Managed Database Infrastructure
# ==============================================================================
# Provisions MySQL database instance with subnet group, automated backups,
# and security configurations for the web application
# ==============================================================================

# ------------------------------------------------------------------------------
# Database Subnet Group
# ------------------------------------------------------------------------------
# Groups private subnets across multiple AZs for RDS high availability
resource "aws_db_subnet_group" "main" {
  name       = "${var.project_name}-db-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name        = "${var.project_name}-db-subnet-group"
    Environment = var.environment
  }
}

# ------------------------------------------------------------------------------
# RDS MySQL Database Instance
# ------------------------------------------------------------------------------
# Managed MySQL database with automated backups, maintenance, and monitoring
resource "aws_db_instance" "main" {
  identifier             = "${var.project_name}-db"
  allocated_storage      = var.allocated_storage
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = var.engine_version
  instance_class         = var.instance_class
  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password
  parameter_group_name   = "default.mysql8.0"
  skip_final_snapshot    = true                         # Set to false in production for data protection
  vpc_security_group_ids = [var.db_security_group_id]
  db_subnet_group_name   = aws_db_subnet_group.main.name
  publicly_accessible    = false                        # Database not accessible from internet

  tags = {
    Name        = "${var.project_name}-rds"
    Environment = var.environment
  }
}
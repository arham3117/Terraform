# ==============================================================================
# Security Groups Module - Network Access Controls
# ==============================================================================
# Defines security groups (virtual firewalls) for web and database tiers
# implementing least-privilege access and layer isolation
# ==============================================================================

# ------------------------------------------------------------------------------
# Web Server Security Group
# ------------------------------------------------------------------------------
# Controls inbound/outbound traffic for EC2 instances in public subnet
resource "aws_security_group" "web" {
  name        = "${var.project_name}-web-sg"
  description = "Security group for web server - allows HTTP and SSH"
  vpc_id      = var.vpc_id

  # Allow HTTP traffic from internet for web application access
  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow SSH access for server management and troubleshooting
  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic for package downloads, updates, and database connections
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_name}-web-sg"
    Environment = var.environment
  }
}

# ------------------------------------------------------------------------------
# Database Security Group
# ------------------------------------------------------------------------------
# Restricts database access to web tier only, preventing direct internet access
resource "aws_security_group" "db" {
  name        = "${var.project_name}-db-sg"
  description = "Security group for RDS - allows MySQL from web server only"
  vpc_id      = var.vpc_id

  # Allow MySQL connections only from web server security group
  ingress {
    description     = "MySQL from web server"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.web.id]
  }

  # Allow outbound traffic for updates and patches
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_name}-db-sg"
    Environment = var.environment
  }
}
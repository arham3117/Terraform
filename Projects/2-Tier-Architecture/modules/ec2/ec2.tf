# ==============================================================================
# EC2 Module - Web Server Infrastructure
# ==============================================================================
# Provisions EC2 instance with Flask application, automated setup via user
# data script, and database connectivity configuration
# ==============================================================================

# ------------------------------------------------------------------------------
# AMI Data Source
# ------------------------------------------------------------------------------
# Retrieves latest official Ubuntu 22.04 LTS AMI from Canonical
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical - Official Ubuntu AMI publisher
}

# ------------------------------------------------------------------------------
# EC2 Web Server Instance
# ------------------------------------------------------------------------------
# Ubuntu instance with Flask app deployed via user data script
resource "aws_instance" "web" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = var.public_subnet_id
  vpc_security_group_ids      = [var.web_security_group_id]
  associate_public_ip_address = true

  # User data script installs and configures Flask application with database connection
  user_data = templatefile("${path.module}/templates/user_data.sh", {
    db_host     = var.db_host
    db_username = var.db_username
    db_password = var.db_password
    db_name     = var.db_name
  })

  tags = {
    Name        = "${var.project_name}-web-server"
    Environment = var.environment
  }
}
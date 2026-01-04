# ============================================================================
# Data Sources
# ============================================================================
# This file contains data sources for dynamically retrieving information
# from AWS, such as availability zones and AMI IDs.

# ----------------------------------------------------------------------------
# Availability Zones - Primary Region
# ----------------------------------------------------------------------------
# Retrieves list of available availability zones in the primary region
# This ensures subnets are created in valid AZs
data "aws_availability_zones" "primary" {
  provider = aws.primary
  state    = "available"  # Only get AZs that are currently available
}

# ----------------------------------------------------------------------------
# Availability Zones - Secondary Region
# ----------------------------------------------------------------------------
# Retrieves list of available availability zones in the secondary region
data "aws_availability_zones" "secondary" {
  provider = aws.secondary
  state    = "available"  # Only get AZs that are currently available
}

# ----------------------------------------------------------------------------
# AMI - Primary Region (Ubuntu 24.04 LTS)
# ----------------------------------------------------------------------------
# Dynamically fetches the latest Ubuntu 24.04 LTS AMI in the primary region
# This ensures instances always use the latest patched version
data "aws_ami" "primary_ami" {
  provider    = aws.primary
  most_recent = true                  # Get the most recent AMI matching filters
  owners      = ["099720109477"]      # Canonical's AWS account ID (official Ubuntu images)

  # Filter for Ubuntu 24.04 LTS (Noble Numbat) server images
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  # Ensure we get HVM (Hardware Virtual Machine) virtualization type
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  # Specify 64-bit x86 architecture
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

# ----------------------------------------------------------------------------
# AMI - Secondary Region (Ubuntu 24.04 LTS)
# ----------------------------------------------------------------------------
# Dynamically fetches the latest Ubuntu 24.04 LTS AMI in the secondary region
# AMI IDs differ across regions, so we need separate data sources
data "aws_ami" "secondary_ami" {
  provider    = aws.secondary
  most_recent = true                  # Get the most recent AMI matching filters
  owners      = ["099720109477"]      # Canonical's AWS account ID (official Ubuntu images)

  # Filter for Ubuntu 24.04 LTS (Noble Numbat) server images
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  # Ensure we get HVM (Hardware Virtual Machine) virtualization type
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  # Specify 64-bit x86 architecture
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}
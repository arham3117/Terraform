# ==============================================================================
# VPC Module - Network Infrastructure
# ==============================================================================
# Creates VPC with DNS support, public subnet for web tier, and private
# subnets for database tier across multiple availability zones
# ==============================================================================

# ------------------------------------------------------------------------------
# VPC Resource
# ------------------------------------------------------------------------------
# Creates isolated virtual network with DNS hostname and resolution enabled
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "${var.project_name}-vpc"
    Environment = var.environment
  }
}

# ------------------------------------------------------------------------------
# Public Subnet
# ------------------------------------------------------------------------------
# Subnet for internet-facing resources (EC2 web server) with auto-assigned
# public IPs for direct internet access
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr
  map_public_ip_on_launch = true
  availability_zone       = "${var.aws_region}a"

  tags = {
    Name        = "${var.project_name}-public-subnet"
    Environment = var.environment
  }
}

# ------------------------------------------------------------------------------
# Private Subnets
# ------------------------------------------------------------------------------
# RDS requires DB subnet group spanning minimum 2 availability zones for
# high availability and automated failover capability

# Private subnet in first availability zone
resource "aws_subnet" "private_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidrs[0]
  availability_zone = "${var.aws_region}a"

  tags = {
    Name        = "${var.project_name}-private-subnet-1"
    Environment = var.environment
  }
}

# Private subnet in second availability zone
resource "aws_subnet" "private_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidrs[1]
  availability_zone = "${var.aws_region}b"

  tags = {
    Name        = "${var.project_name}-private-subnet-2"
    Environment = var.environment
  }
}

# ------------------------------------------------------------------------------
# Internet Gateway
# ------------------------------------------------------------------------------
# Enables communication between VPC resources and the internet
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.project_name}-igw"
    Environment = var.environment
  }
}

# ------------------------------------------------------------------------------
# Routing Configuration
# ------------------------------------------------------------------------------
# Route table directing all non-local traffic through internet gateway
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name        = "${var.project_name}-public-rt"
    Environment = var.environment
  }
}

# Associate public subnet with route table for internet access
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}
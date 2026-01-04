# ============================================================================
# VPC Peering Infrastructure Configuration
# ============================================================================
# This file contains all AWS infrastructure resources for cross-region VPC
# peering, including VPCs, subnets, routing, security groups, and EC2 instances.

# ============================================================================
# SECTION 1: Virtual Private Clouds (VPCs)
# ============================================================================

# ----------------------------------------------------------------------------
# Primary VPC (us-east-1)
# ----------------------------------------------------------------------------
# Creates the primary VPC in the us-east-1 region with DNS support enabled
# DNS hostnames and resolution are required for proper instance communication
resource "aws_vpc" "primary_vpc" {
  cidr_block           = "10.0.0.0/16"     # Provides 65,536 IP addresses
  provider             = aws.primary
  enable_dns_hostnames = true              # Enables DNS hostnames for instances
  enable_dns_support   = true              # Enables DNS resolution within the VPC

  tags = {
    Name = "Primary-VPC-${var.primary}"
  }
}

# ----------------------------------------------------------------------------
# Secondary VPC (us-west-2)
# ----------------------------------------------------------------------------
# Creates the secondary VPC in the us-west-2 region with DNS support enabled
# CIDR block must not overlap with primary VPC for peering to work
resource "aws_vpc" "secondary_vpc" {
  cidr_block           = "10.1.0.0/16"     # Provides 65,536 IP addresses (non-overlapping)
  provider             = aws.secondary
  enable_dns_hostnames = true              # Enables DNS hostnames for instances
  enable_dns_support   = true              # Enables DNS resolution within the VPC

  tags = {
    Name = "Secondary-VPC-${var.secondary}"
  }
}

# ============================================================================
# SECTION 2: Subnets
# ============================================================================

# ----------------------------------------------------------------------------
# Primary Subnet (us-east-1)
# ----------------------------------------------------------------------------
# Creates a public subnet in the primary VPC
# Instances in this subnet will be able to communicate with the internet and secondary VPC
resource "aws_subnet" "primary_subnet" {
  vpc_id            = aws_vpc.primary_vpc.id
  cidr_block        = var.primary_vpc_cidr               # Uses entire VPC CIDR range
  provider          = aws.primary
  availability_zone = data.aws_availability_zones.primary.names[0]  # Uses first available AZ

  tags = {
    Name        = "Primary-Subnet-${var.primary}"
    Environment = "Primary-${var.environment}"
  }
}

# ----------------------------------------------------------------------------
# Secondary Subnet (us-west-2)
# ----------------------------------------------------------------------------
# Creates a public subnet in the secondary VPC
# Instances in this subnet will be able to communicate with the internet and primary VPC
resource "aws_subnet" "secondary_subnet" {
  vpc_id            = aws_vpc.secondary_vpc.id
  cidr_block        = var.secondary_vpc_cidr             # Uses entire VPC CIDR range
  provider          = aws.secondary
  availability_zone = data.aws_availability_zones.secondary.names[0]  # Uses first available AZ

  tags = {
    Name        = "Secondary-Subnet-${var.secondary}"
    Environment = "Secondary-${var.environment}"
  }
}

# ============================================================================
# SECTION 3: Internet Gateways
# ============================================================================

# ----------------------------------------------------------------------------
# Primary Internet Gateway
# ----------------------------------------------------------------------------
# Provides internet connectivity to resources in the primary VPC
# Required for instances to communicate with the internet and for SSH access
resource "aws_internet_gateway" "primary_igw" {
  vpc_id   = aws_vpc.primary_vpc.id
  provider = aws.primary

  tags = {
    Name        = "Primary-IGW-${var.primary}"
    Environment = "Primary-${var.environment}"
  }
}

# ----------------------------------------------------------------------------
# Secondary Internet Gateway
# ----------------------------------------------------------------------------
# Provides internet connectivity to resources in the secondary VPC
# Required for instances to communicate with the internet and for SSH access
resource "aws_internet_gateway" "secondary_igw" {
  vpc_id   = aws_vpc.secondary_vpc.id
  provider = aws.secondary

  tags = {
    Name        = "Secondary-IGW-${var.secondary}"
    Environment = "Secondary-${var.environment}"
  }
}

# ============================================================================
# SECTION 4: Route Tables
# ============================================================================

# ----------------------------------------------------------------------------
# Primary Route Table
# ----------------------------------------------------------------------------
# Defines routing rules for the primary VPC
# Includes a default route to the internet gateway for outbound internet access
resource "aws_route_table" "primary_route_table" {
  vpc_id   = aws_vpc.primary_vpc.id
  provider = aws.primary

  # Default route to internet gateway (0.0.0.0/0 = all internet traffic)
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.primary_igw.id
  }

  tags = {
    Name        = "Primary-Route-Table-${var.primary}"
    Environment = "Primary-${var.environment}"
  }
}

# ----------------------------------------------------------------------------
# Secondary Route Table
# ----------------------------------------------------------------------------
# Defines routing rules for the secondary VPC
# Includes a default route to the internet gateway for outbound internet access
resource "aws_route_table" "secondary_route_table" {
  vpc_id   = aws_vpc.secondary_vpc.id
  provider = aws.secondary

  # Default route to internet gateway (0.0.0.0/0 = all internet traffic)
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.secondary_igw.id
  }

  tags = {
    Name        = "Secondary-Route-Table-${var.secondary}"
    Environment = "Secondary-${var.environment}"
  }
}

# ============================================================================
# SECTION 5: Route Table Associations
# ============================================================================

# ----------------------------------------------------------------------------
# Primary Subnet Route Table Association
# ----------------------------------------------------------------------------
# Associates the primary subnet with the primary route table
# This applies all routing rules defined in the route table to the subnet
resource "aws_route_table_association" "primary_route_table_association" {
  provider       = aws.primary
  subnet_id      = aws_subnet.primary_subnet.id
  route_table_id = aws_route_table.primary_route_table.id
}

# ----------------------------------------------------------------------------
# Secondary Subnet Route Table Association
# ----------------------------------------------------------------------------
# Associates the secondary subnet with the secondary route table
# This applies all routing rules defined in the route table to the subnet
resource "aws_route_table_association" "secondary_route_table_association" {
  provider       = aws.secondary
  subnet_id      = aws_subnet.secondary_subnet.id
  route_table_id = aws_route_table.secondary_route_table.id
}

# ============================================================================
# SECTION 6: VPC Peering Connection
# ============================================================================

# ----------------------------------------------------------------------------
# VPC Peering Connection Request
# ----------------------------------------------------------------------------
# Creates a cross-region VPC peering connection from primary to secondary VPC
# This allows private network communication between the two VPCs
# Note: Cross-region peering requires acceptance in the peer region
resource "aws_vpc_peering_connection" "primary_to_secondary" {
  provider      = aws.primary
  vpc_id        = aws_vpc.primary_vpc.id        # Requester VPC (us-east-1)
  peer_vpc_id   = aws_vpc.secondary_vpc.id      # Accepter VPC (us-west-2)
  peer_region   = var.secondary                 # Region of peer VPC
  auto_accept   = false                         # Cannot auto-accept cross-region peering

  tags = {
    Name        = "Primary_to_Secondary-${var.environment}"
    Environment = var.environment
    Side        = "Requester"
  }
}

# ----------------------------------------------------------------------------
# VPC Peering Connection Accepter
# ----------------------------------------------------------------------------
# Automatically accepts the peering connection request in the secondary region
# Required for cross-region peering to become active
resource "aws_vpc_peering_connection_accepter" "secondary_accepter" {
  provider                  = aws.secondary
  vpc_peering_connection_id = aws_vpc_peering_connection.primary_to_secondary.id
  auto_accept               = true                      # Automatically accept the connection

  tags = {
    Name        = "Secondary_Accepter-${var.environment}"
    Environment = var.environment
    Side        = "Accepter"
  }

  # Ensure peering request exists before attempting to accept
  depends_on = [aws_vpc_peering_connection.primary_to_secondary]
}

# ============================================================================
# SECTION 7: VPC Peering Routes
# ============================================================================

# ----------------------------------------------------------------------------
# Primary to Secondary VPC Route
# ----------------------------------------------------------------------------
# Adds a route in the primary VPC's route table to direct traffic
# destined for the secondary VPC's CIDR through the peering connection
resource "aws_route" "primary_to_secondary_route" {
  provider                  = aws.primary
  route_table_id            = aws_route_table.primary_route_table.id
  destination_cidr_block    = var.secondary_vpc_cidr                           # Traffic for 10.1.0.0/16
  vpc_peering_connection_id = aws_vpc_peering_connection.primary_to_secondary.id

  # Wait for peering connection to be accepted before adding route
  depends_on = [aws_vpc_peering_connection_accepter.secondary_accepter]
}

# ----------------------------------------------------------------------------
# Secondary to Primary VPC Route
# ----------------------------------------------------------------------------
# Adds a route in the secondary VPC's route table to direct traffic
# destined for the primary VPC's CIDR through the peering connection
resource "aws_route" "secondary_to_primary_route" {
  provider                  = aws.secondary
  route_table_id            = aws_route_table.secondary_route_table.id
  destination_cidr_block    = var.primary_vpc_cidr                             # Traffic for 10.0.0.0/16
  vpc_peering_connection_id = aws_vpc_peering_connection.primary_to_secondary.id

  # Wait for peering connection to be accepted before adding route
  depends_on = [aws_vpc_peering_connection_accepter.secondary_accepter]
}


# ============================================================================
# SECTION 8: Security Groups
# ============================================================================

# ----------------------------------------------------------------------------
# Primary VPC Security Group
# ----------------------------------------------------------------------------
# Firewall rules for EC2 instance in the primary VPC
# Allows SSH access from internet and full communication with secondary VPC
resource "aws_security_group" "primary_sg" {
  provider    = aws.primary
  name        = "primary-vpc-sg"
  description = "Security group for Primary VPC instance"
  vpc_id      = aws_vpc.primary_vpc.id

  # Allow SSH access from anywhere (for administrative access)
  # Note: In production, restrict this to specific IP addresses
  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow ICMP (ping) from secondary VPC for connectivity testing
  ingress {
    description = "ICMP from Secondary VPC"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [var.secondary_vpc_cidr]
  }

  # Allow all TCP traffic from secondary VPC (for VPC peering communication)
  ingress {
    description = "All traffic from Secondary VPC"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = [var.secondary_vpc_cidr]
  }

  # Allow all outbound traffic
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "Primary-VPC-SG"
    Environment = "Demo"
  }
}

# ----------------------------------------------------------------------------
# Secondary VPC Security Group
# ----------------------------------------------------------------------------
# Firewall rules for EC2 instance in the secondary VPC
# Allows SSH access from internet and full communication with primary VPC
resource "aws_security_group" "secondary_sg" {
  provider    = aws.secondary
  name        = "secondary-vpc-sg"
  description = "Security group for Secondary VPC instance"
  vpc_id      = aws_vpc.secondary_vpc.id

  # Allow SSH access from anywhere (for administrative access)
  # Note: In production, restrict this to specific IP addresses
  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow ICMP (ping) from primary VPC for connectivity testing
  ingress {
    description = "ICMP from Primary VPC"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [var.primary_vpc_cidr]
  }

  # Allow all TCP traffic from primary VPC (for VPC peering communication)
  ingress {
    description = "All traffic from Primary VPC"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = [var.primary_vpc_cidr]
  }

  # Allow all outbound traffic
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "Secondary-VPC-SG"
    Environment = "Demo"
  }
}

# ============================================================================
# SECTION 9: EC2 Instances
# ============================================================================

# ----------------------------------------------------------------------------
# Primary VPC EC2 Instance
# ----------------------------------------------------------------------------
# Test instance in the primary VPC running Apache web server
# Used to verify cross-region VPC peering connectivity
resource "aws_instance" "primary_instance" {
  provider                    = aws.primary
  ami                         = data.aws_ami.primary_ami.id              # Latest Ubuntu 24.04 LTS
  instance_type               = var.instance_type                        # t2.micro (free tier eligible)
  subnet_id                   = aws_subnet.primary_subnet.id
  vpc_security_group_ids      = [aws_security_group.primary_sg.id]
  key_name                    = var.primary_key_name                     # SSH key for access
  associate_public_ip_address = true                                     # Assign public IP for SSH access

  # Bootstrap script to install and configure Apache
  user_data = local.primary_user_data

  tags = {
    Name        = "Primary-VPC-Instance"
    Environment = "Demo"
    Region      = var.primary
  }

  # Ensure VPC peering is established before creating instance
  depends_on = [aws_vpc_peering_connection_accepter.secondary_accepter]
}

# ----------------------------------------------------------------------------
# Secondary VPC EC2 Instance
# ----------------------------------------------------------------------------
# Test instance in the secondary VPC running Apache web server
# Used to verify cross-region VPC peering connectivity
resource "aws_instance" "secondary_instance" {
  provider                    = aws.secondary
  ami                         = data.aws_ami.secondary_ami.id            # Latest Ubuntu 24.04 LTS
  instance_type               = var.instance_type                        # t2.micro (free tier eligible)
  subnet_id                   = aws_subnet.secondary_subnet.id
  vpc_security_group_ids      = [aws_security_group.secondary_sg.id]
  key_name                    = var.secondary_key_name                   # SSH key for access
  associate_public_ip_address = true                                     # Assign public IP for SSH access

  # Bootstrap script to install and configure Apache
  user_data = local.secondary_user_data

  tags = {
    Name        = "Secondary-VPC-Instance"
    Environment = "Demo"
    Region      = var.secondary
  }

  # Ensure VPC peering is established before creating instance
  depends_on = [aws_vpc_peering_connection_accepter.secondary_accepter]
}
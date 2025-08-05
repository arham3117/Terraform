# This is the code for my EC2 instance
# Key Pair (SSH or Login)
resource "aws_key_pair" "terraform_key" {
    key_name = "${var.env}-infra-app-key"
    public_key = file("arh-terra-key.pub") # Path to your public key file

    tags = {
        Environment = var.env
    }
}
# VPC & Security Group
resource "aws_default_vpc" "default" {
 
}

resource "aws_security_group" "my_security_group" {
  name = "${var.env}-infra-app-sg"
  description = "Terraform Security Group"
  vpc_id = aws_default_vpc.default.id # String Interpolation

  # Inbound rules
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow SSH"
  }
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP"
  }
  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTPS"
  }

  # Outbound rules
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1" # All protocols (-1)
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.env}-infra-app-sg"
    Environment = var.env
  }
}
# EC2 Instance
resource "aws_instance" "my_instance" {
    count = var.instance_count

    depends_on      = [ aws_security_group.my_security_group, aws_key_pair.terraform_key]
    vpc_security_group_ids = [aws_security_group.my_security_group.id]
    key_name = aws_key_pair.terraform_key.key_name
    instance_type   = var.instance_type
    ami             = var.ami_id

    root_block_device {
        volume_size = var.volume_size
        volume_type = "gp3"
    }

    tags = {
        Name = "${var.env}-infra-app-ec2"
        Environment = var.env
    }
  
}


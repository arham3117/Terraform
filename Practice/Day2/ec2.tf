# Key Pair (SSH or Login)
resource "aws_key_pair" "terraform-key" {
    key_name = "terraform-key-ec2"
    public_key = file("terra-key-ec2-Day2.pub")
}
# VPC & Security Group
resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

resource "aws_security_group" "terraform-sg" {
  name = "terraform-sg"
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
}
# EC2 Instance
resource "aws_instance" "terraform-ec2" {
    ami = "ami-0d1b5a8c13042c939"
    instance_type = "t2.micro"
    key_name = aws_key_pair.terraform-key.key_name
    security_groups = [aws_security_group.terraform-sg.name]
    root_block_device {
        volume_size = 8
        volume_type = "gp3"
        delete_on_termination = true
    }
    tags = {
        Name = "Terraform EC2"
    }
}

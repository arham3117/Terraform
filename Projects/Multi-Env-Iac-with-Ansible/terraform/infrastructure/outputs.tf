# This is the code for outputs in Terraform

output "ec2_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.my_instance[*].public_ip
}

output "ec2_private_ip" {
  description = "Private IP of the EC2 instance"
  value       = aws_instance.my_instance[*].private_ip
}

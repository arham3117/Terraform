# Development Infrastructure
# Requirement: 2 EC2 - 1 S3 - 1 DDB

module "dev-infra" {
  source         = "./infrastructure"
  env            = "dev"
  instance_count = 2
  instance_type  = "t2.micro"
  ami_id         = "ami-0d1b5a8c13042c939"
  volume_size    = 10
}

# Staging Infrastructure
# Requirement: 2 EC2 - 1 S3 - 1 DDB
module "stg-infra" {
  source         = "./infrastructure"
  env            = "stg"
  instance_count = 2
  instance_type  = "t2.small"
  ami_id         = "ami-0d1b5a8c13042c939"
  volume_size    = 15
}


# Production Infrastructure
# Requirement: 3 EC2 - 1 S3 - 1 DDB
module "prd-infra" {
  source         = "./infrastructure"
  env            = "prd"
  instance_count = 3
  instance_type  = "t2.medium"
  ami_id         = "ami-0d1b5a8c13042c939"
  volume_size    = 20
}

output "dev_infra_ec2_public_ips" {
  value = module.dev-infra.ec2_public_ip
}

output "stg_infra_ec2_public_ips" {
  value = module.stg-infra.ec2_public_ip
}

output "prd_infra_ec2_public_ips" {
  value = module.prd-infra.ec2_public_ip
}
# Dev Infrastructure
module "dev-infra" {
    source = "./infra-app"
    env = "dev"
    bucket_name = "infra-app-bucket-arh"
    instance_count = 1
    instance_type = "t2.micro"
    ec2_ami_id = "ami-0d1b5a8c13042c939" # Ubuntu
    hash_key = "studentID"
}

# Prod Infrastructure
module "prod-infra" {
    source = "./infra-app"
    env = "prod"
    bucket_name = "infra-app-bucket-arh"
    instance_count = 2
    instance_type = "t2.medium"
    ec2_ami_id = "ami-0d1b5a8c13042c939" # Ubuntu
    hash_key = "studentID"
}

# Staging Infrastructure
module "stg-infra" {
    source = "./infra-app"
    env = "stg"
    bucket_name = "infra-app-bucket-arh"
    instance_count = 1
    instance_type = "t2.small"
    ec2_ami_id = "ami-0d1b5a8c13042c939" # Ubuntu
    hash_key = "studentID"
}
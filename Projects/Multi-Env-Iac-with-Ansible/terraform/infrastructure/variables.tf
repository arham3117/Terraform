# Here I have defined all the variables

variable "env" {
    description = "This is environment name Eg. dev/stg/prd"
    type = string
}

variable "instance_type" {
    description = "This is the Instance type for AWS Eg. t2.micro/t2.medium/t2.small"
    type = string
}

variable "instance_count" {
    description = "This is the number of instance I need Eg. 1/3/4"
    type = number
}

variable "ami_id" {
    description = "This is the AMI ID for the EC2 instance"
    type = string
}

variable "volume_size" {
  description = "THis is the size for the root block device"
    type        = number
}
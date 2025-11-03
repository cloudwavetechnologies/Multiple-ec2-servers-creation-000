terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.54.1"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.2"
    }
  }
}

provider "aws" {
  region = var.region
}
# resource "random_id" "rand_id" {
#   byte_length = 8
# }
###########################################################
# ec2 Instances  Creation
###########################################################
resource "aws_instance" "web" {
  count         = var.instance_count
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  tags = {
    Name = "web-${count.index + 1}"
    Project = var.project
  }
}
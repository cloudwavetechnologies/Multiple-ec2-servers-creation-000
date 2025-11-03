variable "region" {
  description = "AWS region"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for EC2 instances"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "instance_count" {
  description = "Number of EC2 instances to create"
  type        = number
}

variable "subnet_id" {
  description = "Subnet ID to launch EC2 instances"
  type        = string
}

variable "project" {
  description = "Project tag"
  type        = string
}

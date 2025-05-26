variable "tags" {
  type = map(string)
}

variable "env" {
  type = string
}

variable "azs" {
  type = list(string)
}

variable "public_subnet_cidrs" {
  type = list(string)
}

variable "private_subnet_cidrs" {
  type = list(string)
}

variable "vpc_cidr" {
  type = string
}

variable "instance_types" {
  type = list(string)
}

# variable "ec2_ssh_key" {
#   type = string
# }

variable "db_username" {
  type = string
}

variable "db_name" {
  type = string
}

variable "db_password" {
  type = string
}

variable "aws_region" {
  type = string
}



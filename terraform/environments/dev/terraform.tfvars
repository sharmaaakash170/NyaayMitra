aws_region = "us-east-1"
env = "dev"
tags = {
  Name        = "NyaayMitra"
  Project     = "lawyer-ca-marketplace"
}
vpc_cidr = "10.0.0.0/16"
public_subnet_cidrs = [ "10.0.1.0/24", "10.0.2.0/24" ]
private_subnet_cidrs = [ "10.0.3.0/24", "10.0.4.0/24" ]
azs = [ "us-east-1a", "us-east-1b" ]
instance_types = [ "t3.medium" ]
# ec2_ssh_key = "terraform.pem"
db_name = "datatabletesingphase"
db_password = "admintestpassword"
db_username = "admin"
terraform {
  backend "s3" {
    bucket = "dev-environment-state-lock-bucket-nyaay-mitra"
    key = "dev/terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt = true
  }
}
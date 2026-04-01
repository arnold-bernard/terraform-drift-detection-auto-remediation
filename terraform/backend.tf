terraform {
  backend "s3" {
    bucket         = "arnold-terraform-state"
    key            = "drift/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-locks"
  }
}
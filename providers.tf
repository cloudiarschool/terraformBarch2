provider "aws" {
  region = var.aws_region
}

terraform {
  backend "s3" {
    bucket         = "terraform-state-cloudiar"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "cloudiar-tf"
  }
}

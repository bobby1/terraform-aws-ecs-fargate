# Configure the AWS Provider
provider "aws" {
  region = var.region
}
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
terraform {
  backend "s3" {
    bucket         = "b1dev-terraform-state"
    key            = "dev/ecs/terraform.tfstate"
    region         = "us-west-1"
    dynamodb_table = "devops-ecs-terraform-locking"
    encrypt        = true
  }
}
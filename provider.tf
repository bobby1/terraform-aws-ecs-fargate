# Configure the AWS Provider
provider "aws" {
  region = var.region
  default_tags {
    tags = {
      business_divsion = var.business_division
      environment      = var.environment
    }
  }
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
    bucket       = "b1dev-terraform-state"
    key          = "dev/ecs/terraform.tfstate"
    region       = "us-west-1"
    use_lockfile = true
    encrypt      = true
  }
}
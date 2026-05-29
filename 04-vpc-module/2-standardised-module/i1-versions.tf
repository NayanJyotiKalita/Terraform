terraform {
  required_version = "~> 1.15.4"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 6.47"
    }
  }
}

provider "aws" {
  region = var.aws_region
  profile = "default"
}

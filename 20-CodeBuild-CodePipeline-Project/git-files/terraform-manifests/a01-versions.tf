terraform {
  required_version = "~> 1.15.4"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.52.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.9.0"
    }
  }

  backend "s3" {}  # Configured in the .conf files for each environments
}

provider "aws" {
    region = var.aws_region
}

resource "random_pet" "random" {
  length = 3
}

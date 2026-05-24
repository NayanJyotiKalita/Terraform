terraform {
  required_version = "~> 1.15.0"
  required_providers {
    aws-iac = {
      source = "hashicorp.com/aws"
      version = "~> 5.92"
    }
  }
}

provider "aws-iac" {
  region = "us-west-2"
  profile = default
}


/*
Note-1:  AWS Credentials Profile (profile = "default") configured on your local desktop terminal  
$HOME/.aws/credentials

else if you need to use a different profile, follow below
provider "aws" {
  region = "us-east-1"
  profile = "<profilename>" #profilename to be picked from $HOME/.aws/credentials file 
}
*/
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.60"
    }
  }
  required_version = "= 1.5.0"
}

provider "aws" {
  region  = "us-east-1"
  access_key="xxx"
  secret_key="xxx"
}

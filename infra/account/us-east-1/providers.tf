terraform {
  required_providers {
    alks = {
      source  = "cox-automotive/alks"
      version = "~> 2.7"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.60"
    }
  }
  required_version = "= 1.5.0"
}

provider "aws" {
  region  = "us-east-1"
}

provider "aws" {
  alias = "sns_homie_east"
  region  = "us-east-1"
}

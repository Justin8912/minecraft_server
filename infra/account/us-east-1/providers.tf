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
  access_key="AKIAYWBSQQOX6IGIQCAZ"
  secret_key="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"
}

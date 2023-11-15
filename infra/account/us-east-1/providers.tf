terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.60"
    }
  }
  required_version = "= 1.5.0"
}

locals {
  csv_data = csvdecode(file("${path.root}/../../../secrets/minecraft-super-user_accessKeys.csv"))
}

provider "aws" {
  region = "us-east-1"
  access_key = local.csv_data[0]["﻿accessKeyId"]
  secret_key = local.csv_data[0].secretAccessKey
}

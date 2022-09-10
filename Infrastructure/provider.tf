terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region="${var.AWS_REGION}"
  access_key = "$ACCESS_KEY"
  secret_key = "$SECRET_ACCESS_KEY"
}
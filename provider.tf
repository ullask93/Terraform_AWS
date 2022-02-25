terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }

  backend "s3" {
    bucket = "tf-state-assign"
    key = "dev/terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "tf-state-table"
  }
}

provider "aws" {
  region = "us-east-1"
}

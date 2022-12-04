terraform {
  backend "s3" {
    bucket = "stockperks-infra-tfstate"
    key    = "basic/infrastructure.tfstate"
    region = "us-east-1"
  }
  required_version = ">= 0.13.7"
}

provider "aws" {
  region = var.region
}

provider "aws" {
  alias  = "west"
  region = "us-west-2"
}

provider "aws" {
  alias  = "us-east-2"
  region = "us-east-2"
}

provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"
}

data "aws_canonical_user_id" "current" {}

terraform {
  backend "s3" {
    bucket = "stockperks-infra-tfstate"
    key    = "develop-cluster/infrastructure.tfstate"
    region = "us-east-1"
  }
  required_version = ">= 0.13.7"
}

provider "aws" {
  region = var.region
}

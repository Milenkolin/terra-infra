terraform {
  backend "s3" {
    bucket = "stockperks-infra-tfstate"
    key    = "prod-cluster/data-propagation-service/infrastructure.tfstate"
    region = "us-east-1"
  }
  required_version = ">= 0.13.7"
}

data "terraform_remote_state" "prod_cluster" {
  backend = "s3"
  config = {
    bucket = "stockperks-infra-tfstate"
    key    = "prod-cluster/infrastructure.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "basic" {
  backend = "s3"
  config = {
    bucket = "stockperks-infra-tfstate"
    key    = "basic/infrastructure.tfstate"
    region = "us-east-1"
  }
}

locals {
  env = data.terraform_remote_state.prod_cluster.outputs.environment
  region = data.terraform_remote_state.prod_cluster.outputs.region
}

provider "aws" {
  region = local.region
}
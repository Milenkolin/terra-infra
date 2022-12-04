terraform {
  backend "s3" {
    bucket = "stockperks-infra-tfstate"
    key    = "develop-cluster/api-service/infrastructure.tfstate"
    region = "us-east-1"
  }
  required_version = ">= 0.13.7"
}

data "terraform_remote_state" "develop_cluster" {
  backend = "s3"
  config = {
    bucket = "stockperks-infra-tfstate"
    key    = "develop-cluster/infrastructure.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = data.terraform_remote_state.develop_cluster.outputs.region
}

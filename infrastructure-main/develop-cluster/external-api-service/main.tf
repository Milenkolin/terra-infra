terraform {
  backend "s3" {
    bucket = "stockperks-infra-tfstate"
    key    = "develop-cluster/external-api-service/infrastructure.tfstate"
    region = "us-east-1"
    #shared_credentials_file = "~/.aws/credentials"
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

data "terraform_remote_state" "basic" {
  backend = "s3"
  config = {
    bucket = "stockperks-infra-tfstate"
    key    = "basic/infrastructure.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = data.terraform_remote_state.develop_cluster.outputs.region
}

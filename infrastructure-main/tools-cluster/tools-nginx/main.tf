terraform {
  backend "s3" {
    bucket = "stockperks-infra-tfstate"
    key    = "tools-cluster/tools-nginx/infrastructure.tfstate"
    region = "us-east-1"
    #shared_credentials_file = "~/.aws/credentials"
  }
  required_version = ">= 0.13.7"
}

data "terraform_remote_state" "tools_cluster" {
  backend = "s3"
  config = {
    bucket = "stockperks-infra-tfstate"
    key    = "tools-cluster/infrastructure.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = data.terraform_remote_state.tools_cluster.outputs.region
}

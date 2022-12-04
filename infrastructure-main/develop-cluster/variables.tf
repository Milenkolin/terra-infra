variable "region" {
  type        = string
  description = "AWS region."
  default     = "us-east-1"
}

variable "environment" {
  type        = string
  description = "Deployment environment: develop or prod."
  default     = "develop"
}

variable "ecs_cluster_iam_role_arn" {
  type        = string
  description = "ARN of ECS cluster IAM role."
  default     = "arn:aws:iam::979370138172:role/aws-service-role/ecs.amazonaws.com/AWSServiceRoleForECS"
}

#vars for vpc_develop_cluster
variable "cidr_dev_vpc" {
  type        = string
  description = "Cidr block vpc-dev-cluster"
  default     = "13.0.0.0/16"
}

variable "dhcp_options_id_dev_vpc" {
  type        = string
  description = "Id DHCP option for vpc-dev-cluster"
  default     = "dopt-05923193e49eba2d9"
}

variable "cidr_dev_private_subnet_us-east-1a" {
  type        = string
  description = "Cidr block private-subnet-1-develop-cluster"
  default     = "13.0.2.0/24"
}

variable "route_table_id_dev_private_subnet_us-east-1a" {
  type        = string
  description = "Id route table for private-subnet-1-develop-cluster"
  default     = "rtb-09ff53908c2b0c98b"
}

variable "cidr_dev_private_subnet_us-east-1b" {
  type        = string
  description = "Cidr block private-subnet-2-develop-cluster"
  default     = "13.0.3.0/24"
}

variable "route_table_id_dev_private_subnet_us-east-1b" {
  type        = string
  description = "Id route table for private-subnet-2-develop-cluster"
  default     = "rtb-0d9077d5c00ce16dc"
}

variable "cidr_dev_public_subnet_us-east-1a" {
  type        = string
  description = "Cidr block public-subnet-1-dev-cluster"
  default     = "13.0.0.0/24"
}

variable "route_table_id_dev_public_subnets" {
  type        = string
  description = "Id route table for public-subnets"
  default     = "rtb-0a9498fce27d19f4b"
}

variable "cidr_dev_public_subnet_us-east-1b" {
  type        = string
  description = "Cidr block public-subnet-2-dev-cluster"
  default     = "13.0.1.0/24"
}

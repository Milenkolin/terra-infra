variable "region" {
  type        = string
  description = "AWS region."
  default     = "us-east-1"
}

variable "environment" {
  type        = string
  description = "Deployment environment: develop or prod."
  default     = "prod"
}

variable "ecs_cluster_iam_role_arn" {
  type        = string
  description = "ARN of ECS cluster IAM role."
  default     = "arn:aws:iam::979370138172:role/aws-service-role/ecs.amazonaws.com/AWSServiceRoleForECS"
}

variable "ecs_cluster_iam_role" {
  type        = string
  description = "ECS cluster IAM role."
  default     = "aws-service-role"
}

#vars for vpc_prod_cluster
variable "cidr_prod_vpc" {
  type        = string
  description = "Cidr block vpc-prod-cluster"
  default     = "12.0.0.0/16"
}

variable "dhcp_options_id_prod_vpc" {
  type        = string
  description = "Id DHCP option for vpc-prod-cluster"
  default     = "dopt-0155e8a11c6cb0649"
}

variable "cidr_prod_private_subnet_us-east-1a" {
  type        = string
  description = "Cidr block private-subnet-1-prod-cluster"
  default     = "12.0.2.0/24"
}

variable "route_table_id_prod_private_subnet_us-east-1a" {
  type        = string
  description = "Id route table for private-subnet-1-prod-cluster"
  default     = "rtb-0b7de8d6740135276"
}

variable "cidr_prod_private_subnet_us-east-1b" {
  type        = string
  description = "Cidr block private-subnet-2-prod-cluster"
  default     = "12.0.3.0/24"
}

variable "route_table_id_prod_private_subnet_us-east-1b" {
  type        = string
  description = "Id route table for private-subnet-2-prod-cluster"
  default     = "rtb-04591644059edc7f5"
}

variable "cidr_prod_public_subnet_us-east-1a" {
  type        = string
  description = "Cidr block public-subnet-1-prod-cluster"
  default     = "12.0.0.0/24"
}

variable "route_table_id_prod_public_subnets" {
  type        = string
  description = "Id route table for public-subnets in prod vpc"
  default     = "rtb-02d88b5dcfb8edbee"
}

variable "cidr_prod_public_subnet_us-east-1b" {
  type        = string
  description = "Cidr block public-subnet-2-prod-cluster"
  default     = "12.0.1.0/24"
}

variable "sg_for_lb_1SB3" {
  type        = string
  description = "Id security groups for Load Balncer prod-LoadB-1SB3ODZ5BEMH0"
  default     = "sg-061c1154c329148c9"
}

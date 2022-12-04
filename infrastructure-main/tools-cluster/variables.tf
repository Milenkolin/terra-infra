variable "region" {
  type        = string
  description = "AWS region."
  default     = "us-east-1"
}

#vars for vpc_tools_cluster
variable "cidr_tools_vpc" {
  type        = string
  description = "Cidr block vpc-tools-cluster"
  default     = "11.0.0.0/16"
}

variable "dhcp_options_id_tools_vpc" {
  type        = string
  description = "Id DHCP option for vpc-tools-cluster"
  default     = "dopt-01b494ab486030ffd"
}

variable "cidr_tools_private_subnet_us-east-1a" {
  type        = string
  description = "Cidr block private-subnet-1-tools-cluster"
  default     = "11.0.2.0/24"
}

variable "route_table_id_tools_private_subnet_us-east-1a" {
  type        = string
  description = "Id route table for private-subnet-1-tools-cluster"
  default     = "rtb-05e9650717a0819db"
}

variable "cidr_tools_private_subnet_us-east-1b" {
  type        = string
  description = "Cidr block private-subnet-2-tools-cluster"
  default     = "11.0.3.0/24"
}

variable "route_table_id_tools_private_subnet_us-east-1b" {
  type        = string
  description = "Id route table for private-subnet-2-tools-cluster"
  default     = "rtb-0dd1adb07a50af2cd"
}


variable "cidr_jenkins_tools_private_subnet_us-east-1a" {
  type        = string
  description = "Cidr block private-subnet-1-tools-jenkins-cluster"
  default     = "11.0.4.0/24"
}


variable "cidr_jenkins_tools_private_subnet_us-east-1b" {
  type        = string
  description = "Cidr block private-subnet-2-tools-jenkins-cluster"
  default     = "11.0.5.0/24"
}


variable "cidr_tools_public_subnet_us-east-1a" {
  type        = string
  description = "Cidr block public-subnet-1-tools-cluster"
  default     = "11.0.0.0/24"
}

variable "route_table_id_tools_public_subnets" {
  type        = string
  description = "Id route table for public-subnets in tools vpc"
  default     = "rtb-08cc33ddcc5bd6a85"
}

variable "cidr_tools_public_subnet_us-east-1b" {
  type        = string
  description = "Cidr block public-subnet-2-tools-cluster"
  default     = "11.0.1.0/24"
}

variable "infra_vpc_id" {
  type        = string
  description = "Identifier of ECS cluster VPC."
  default     = "vpc-04854b20dd9b25273"
}

variable "infra_vpc_cidr_blocks" {
  type        = list(any)
  description = "List of CIDR blocks of ECS cluster VPC."
  default     = ["13.0.0.0/16"]
}

variable "infra_vpc_subnet_ids" {
  type        = list(any)
  description = "List of subnet identifiers of ECS cluster VPC."
  default     = ["subnet-0b0a6d96b7a5abde1", "subnet-09fa554832b40855e"]
}

variable "ecs_cluster_id" {
  type        = string
  description = "Identifier of ECS cluster."
  default     = "tools-cluster"
}

variable "ecs_cluster_iam_role_arn" {
  type        = string
  description = "ARN of ECS cluster IAM role."
  default     = "arn:aws:iam::979370138172:role/aws-service-role/ecs.amazonaws.com/AWSServiceRoleForECS"
}

variable "ec2_id_for_tg_tools_metabase_nginx" {
  type        = string
  description = "Id instance in tools-nginx-metabase target group"
  default     = "i-0689af1cb57a239dd"
}

variable "ami_for_ec2_tools_cluster" {
  type        = string
  description = "AMI id  imported EC2 for service tools cluster"
  default     = "ami-0e2efdaddecea9838"
}

variable "iam_role_for_ec2_tools_cluster" {
  type        = string
  description = "id iam role imported EC2 for service tools cluster"
  default     = "tools-kibana-ec2-EC2InstanceProfile-CT728A4AJ5YX"
}

variable "sg_for_ec2_tools_cluster" {
  type        = string
  description = "id security group imported EC2 for service tools cluster"
  default     = "sg-0222d7e446b7242e7"
}

variable "subnet_id_for_ec2_in_az_a_tools_cluster" {
  type        = string
  description = "subnet id imported EC2 in a availibility zone for service tools cluster"
  default     = "subnet-0eff3147d2e775bd6"
}


variable "subnet_id_for_ec2_in_az_b_tools_cluster" {
  type        = string
  description = "subnet id imported EC2 in us-east-b availibility zone for service tools cluster"
  default     = "subnet-0845f68f97c9203b7"
}

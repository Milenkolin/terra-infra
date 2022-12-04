output "region" {
  value = var.region
}

output "environment" {
  value = var.environment
}

output "vpc_id" {
  value = aws_vpc.vpc_develop_cluster.id
}

output "vpc_cidr_block" {
  value = var.cidr_dev_vpc
}

output "private_subnet_id_us-east-1a" {
  value = aws_subnet.private_subnet_us-east-1a.id
}

output "private_subnet_id_us-east-1b" {
  value = aws_subnet.private_subnet_us-east-1b.id
}

output "public_subnet_id_us-east-1a" {
  value = aws_subnet.public_subnet_us-east-1a.id
}

output "public_subnet_id_us-east-1b" {
  value = aws_subnet.public_subnet_us-east-1b.id
}

output "cluster_name" {
  value = aws_ecs_cluster.develop_cluster.name
}

output "develop_capacity_provider" {
  value = aws_ecs_capacity_provider.develop_1.name
}

output "cluster_iam_role" {
  value = var.ecs_cluster_iam_role_arn
}
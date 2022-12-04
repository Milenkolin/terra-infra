output "region" {
  value = var.region
}

output "vpc_id" {
  value = aws_vpc.vpc_tools_cluster.id
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
  value = aws_ecs_cluster.tools_cluster.name
}

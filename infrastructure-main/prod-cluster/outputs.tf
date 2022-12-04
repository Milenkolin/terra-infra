output "region" {
  value = var.region
}

output "environment" {
  value = var.environment
}

output "vpc_id" {
  value = aws_vpc.vpc_prod_cluster.id
}

output "vpc_cidr_block" {
  value = var.cidr_prod_vpc
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
  value = aws_ecs_cluster.prod_cluster.name
}

output "capacity_provider" {
  value = aws_ecs_capacity_provider.prod_2.name
}

output "cluster_iam_role" {
  value = var.ecs_cluster_iam_role_arn
}

output "lb_1SB3_dns_name" {
  value = aws_lb.lb_1SB3.dns_name
}

output "lb_1SB3_zone_id" {
  value = aws_lb.lb_1SB3.zone_id
}

output "tg_external_api_arn" {
  value = aws_lb_target_group.external_api.arn
}

output "tg_perk_central_arn" {
  value = aws_lb_target_group.perk_central.arn
}

output "tg_website_backend_arn" {
  value = aws_lb_target_group.website_backend.arn
}

output "tg_website_v2_arn" {
  value = aws_lb_target_group.website_v2.arn
}

resource "aws_route53_record" "perk_central_service" {
  zone_id = data.terraform_remote_state.basic.outputs.stockperks_com_hosted_zone
  name    = var.perk_central_service_hostname
  type    = "CNAME"
  ttl     = 300
  records = [data.terraform_remote_state.prod_cluster.outputs.lb_1SB3_dns_name]
}

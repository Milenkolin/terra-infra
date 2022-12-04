resource "aws_route53_record" "backend_service" {
  zone_id = data.terraform_remote_state.basic.outputs.stockperks_com_hosted_zone
  name    = var.backend_service_hostname
  type    = "A"

  alias {
    evaluate_target_health = true
    name                   = data.terraform_remote_state.prod_cluster.outputs.lb_1SB3_dns_name
    zone_id                = "Z35SXDOTRQ7X7K"
  }
}

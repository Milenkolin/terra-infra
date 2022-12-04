resource "aws_route53_record" "external_api" {
  zone_id = data.terraform_remote_state.basic.outputs.stockperks_com_hosted_zone
  name    = "api.stockperks.com"
  type    = "A"

  alias {
    evaluate_target_health = false
    name                   = data.terraform_remote_state.prod_cluster.outputs.lb_1SB3_dns_name
    zone_id                = data.terraform_remote_state.prod_cluster.outputs.lb_1SB3_zone_id
  }
}

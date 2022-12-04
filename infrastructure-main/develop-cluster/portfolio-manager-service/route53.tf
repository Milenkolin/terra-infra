resource "aws_route53_record" "portfolio_manager_service" {
  zone_id = data.terraform_remote_state.basic.outputs.stockperks_com_hosted_zone
  name    = local.host_name
  type    = "CNAME"
  ttl     = 60
  records = [aws_lb.portfolio_manager_service.dns_name]
}

resource "aws_route53_record" "configurations_service_dns" {
  zone_id = var.prod_stockperks_internal_hosted_zone_id
  name    = var.configurations_service_hostname
  type    = "A"

  alias {
    name                   = aws_lb.configurations_lb_4X86.dns_name
    zone_id                = aws_lb.configurations_lb_4X86.zone_id
    evaluate_target_health = false
  }
}

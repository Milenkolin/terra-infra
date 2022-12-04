resource "aws_route53_record" "tools_metadata_service_record" {
  zone_id = var.tools_stockperks_internal_hosted_zone_id
  name    = var.tools_metadata_service_hostname
  type    = "A"
  alias {
    evaluate_target_health = false
    name                   = aws_lb.tools_metabase_lb.dns_name
    zone_id                = var.tools_stockperks_internal_hosted_alias_zone_id
  }
}

resource "aws_route53_record" "tools_infra_bot_service_record" {
  zone_id = var.tools_stockperks_internal_hosted_zone_id
  name    = var.tools_infra_bot_service_hostname
  type    = "A"
  alias {
    evaluate_target_health = false
    name                   = aws_lb.tools_metabase_lb.dns_name
    zone_id                = var.tools_stockperks_internal_hosted_alias_zone_id
  }
}

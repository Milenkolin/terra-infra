resource "aws_route53_record" "external_api" {
  zone_id = data.terraform_remote_state.basic.outputs.stockperks_com_hosted_zone
  name    = "api-develop.stockperks.com"
  type    = "CNAME"
  ttl     = 60
  records = ["dualstack.${aws_lb.external_api.dns_name}"]
}

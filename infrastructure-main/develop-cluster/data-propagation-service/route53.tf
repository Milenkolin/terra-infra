resource "aws_route53_record" "data_propagation_service" {
  zone_id = data.terraform_remote_state.basic.outputs.stockperks_com_hosted_zone
  name    = var.data_propagation_service_hostname
  type    = "CNAME"
  ttl     = 60
  records = [aws_lb.data_propagation_lb.dns_name]
}

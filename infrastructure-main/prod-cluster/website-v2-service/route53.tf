resource "aws_route53_record" "website_v2_service_dns_A" {
  zone_id = data.terraform_remote_state.basic.outputs.stockperks_com_hosted_zone
  name    = var.website_v2_service_hostname
  type    = "A"

  alias {
    name                   = var.values_for_a_record
    zone_id                = data.terraform_remote_state.basic.outputs.stockperks_com_hosted_zone
    evaluate_target_health = false
  }
}


resource "aws_route53_record" "website_v2_service_dns_MX" {
  zone_id = data.terraform_remote_state.basic.outputs.stockperks_com_hosted_zone
  name    = var.website_v2_service_hostname
  type    = "MX"
  ttl     = 300

  records = [
    var.values_for_mx_record[0],
    var.values_for_mx_record[1],
    var.values_for_mx_record[2],
    var.values_for_mx_record[3],
    var.values_for_mx_record[4],
  ]
}


resource "aws_route53_record" "website_v2_service_dns_NS" {
  zone_id = data.terraform_remote_state.basic.outputs.stockperks_com_hosted_zone
  name    = var.website_v2_service_hostname
  type    = "NS"
  ttl     = 172800

  records = [
    var.values_for_ns_record[0],
    var.values_for_ns_record[1],
    var.values_for_ns_record[2],
    var.values_for_ns_record[3],
  ]
}


resource "aws_route53_record" "website_v2_service_dns_SOA" {
  zone_id = data.terraform_remote_state.basic.outputs.stockperks_com_hosted_zone
  name    = var.website_v2_service_hostname
  type    = "SOA"
  ttl     = 900

  records = [var.values_for_soa_record]
}

resource "aws_route53_record" "website_v2_service_dns_TXT" {
  zone_id = data.terraform_remote_state.basic.outputs.stockperks_com_hosted_zone
  name    = var.website_v2_service_hostname
  type    = "TXT"
  ttl     = 300

  records = [var.values_for_txt_record]
}

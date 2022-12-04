variable "docker_image_tag" {
  type        = string
  description = "Tag (version) of Docker image."
  default     = "gh-master-33"
}

variable "website_v2_service_hostname" {
  type        = string
  description = "A host name on which the website_v2 service should be available."
  default     = "stockperks.com"
}

variable "values_for_a_record" {
  type        = string
  description = "Values for A type record"
  default     = "www.stockperks.com"
}

variable "values_for_mx_record" {
  type        = list(any)
  description = "List of values for MX type record"
  default     = ["1 ASPMX.L.GOOGLE.COM", "5 ALT1.ASPMX.L.GOOGLE.COM", "5 ALT2.ASPMX.L.GOOGLE.COM", "10 ALT3.ASPMX.L.GOOGLE.COM", "10 ALT4.ASPMX.L.GOOGLE.COM"]
}

variable "values_for_ns_record" {
  type        = list(any)
  description = "List of values for NS type record"
  default     = ["ns-497.awsdns-62.com.", "ns-1009.awsdns-62.net.", "ns-1027.awsdns-00.org.", "ns-1980.awsdns-55.co.uk."]
}

variable "values_for_soa_record" {
  type        = string
  description = "Value for SOA type record"
  default     = "ns-497.awsdns-62.com. awsdns-hostmaster.amazon.com. 1 7200 900 1209600 86400"
}

variable "values_for_txt_record" {
  type        = string
  description = "Value for TXT type record"
  default     = "google-site-verification=-mdtW_FgV5Wv9_CXbBk67Xzfh3Hy8s8-4hbh6GF43BU\" \"v=spf1 include:_spf.google.com include:amazonses.com ~all"
}

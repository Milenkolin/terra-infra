variable "docker_image_tag" {
  type        = string
  description = "Tag (version) of Docker image."
  default     = "gh-v1.12.3-139"
}

variable "sg_for_lb_4X86" {
  type        = string
  description = "Id security groups for Load Balncer prod-LoadB-4X86UTFIMTNT"
  default     = "sg-064ea84b2f5ebfe12"
}

variable "configurations_service_hostname" {
  type        = string
  description = "A host name on which the configurations service should be available."
  default     = "configurations.prod.stockperks.internal"
}

variable "prod_stockperks_internal_hosted_zone_id" {
  type        = string
  description = "Identifier of hosted zone for prod.stockperks.internal."
  default     = "Z0011985EJF3PAB2SLNX"
}

variable "docker_image_tag" {
  type        = string
  description = "Tag (version) of Docker image."
  default     = "gh-develop-179"
}

variable "sg_for_lb_JSY" {
  type        = string
  description = "Id security groups for Load Balncer devel-LoadB-JSYRYJ94MG49"
  default     = "sg-0f61d90f60b58037c"
}

variable "configurations_service_hostname" {
  type        = string
  description = "A host name on which the configurations service should be available."
  default     = "configurations.develop.stockperks.internal"
}

variable "develop_stockperks_internal_hosted_zone_id" {
  type        = string
  description = "Identifier of hosted zone for develop.stockperks.internal."
  default     = "Z022730324GLA5RYP9WE"
}

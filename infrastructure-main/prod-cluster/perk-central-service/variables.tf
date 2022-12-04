variable "docker_image_tag" {
  type        = string
  description = "Tag (version) of Docker image."
  default     = "master-18"
}

variable "perk_central_service_hostname" {
  type        = string
  description = "A host name on which the Perk Central should be available."
  default     = "central.stockperks.com"
}

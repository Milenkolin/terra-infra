variable "docker_image_tag" {
  type        = string
  description = "Tag (version) of Docker image."
  default     = "master-5"
}

variable "backend_service_hostname" {
  type        = string
  description = "A host name on which the website backend Service should be available."
  default     = "site-backend.stockperks.com"
}

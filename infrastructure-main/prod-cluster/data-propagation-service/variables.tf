variable "docker_image_tag" {
  type        = string
  description = "Tag (version) of Docker image."
  default     = "gh-develop-4"
}

variable "data_propagation_service_hostname" {
  type        = string
  description = "A host name on which the Data Propagation Service should be available."
  default     = "data-propagation-service.stockperks.com"
}

variable "data_propagation_service_env" {
  type        = string
  description = "JSON array with environment variable definitions."
  default     = <<EOF
[
    {
        "Name": "DUMMY_VARIABLE",
        "Value": "test"
    }
]
EOF
}

variable "infra_vpc_cidr_blocks" {
  type        = list(any)
  description = "List of CIDR blocks of ECS cluster VPC."
  default     = ["12.0.0.0/16", "11.0.0.0/16", "50.19.45.135/32"]
}

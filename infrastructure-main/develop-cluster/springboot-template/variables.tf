variable "docker_image_tag" {
  type        = string
  description = "Tag (version) of Docker image."
  default     = "v0.0.1-develop"
}

variable "service_env" {
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

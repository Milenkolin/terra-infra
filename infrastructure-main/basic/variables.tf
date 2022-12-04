variable "region" {
  type        = string
  description = "AWS region."
  default     = "us-east-1"
}

variable "stockperks_com_hosted_zone_id" {
  type        = string
  description = "Identifier of hosted zone for stockperks.com."
  default     = "Z22KHS282GD5T3"
}

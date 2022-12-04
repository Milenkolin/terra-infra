variable "tools_metadata_service_hostname" {
  type        = string
  description = "A host name on which the Tools Metadata Service should be available."
  default     = "metabase.tools.stockperks.internal"
}

variable "tools_infra_bot_service_hostname" {
  type        = string
  description = "A host name on which the Infra Bot Service should be available."
  default     = "infra-bot.tools.stockperks.internal"
}

variable "tools_stockperks_internal_hosted_zone_id" {
  type        = string
  description = "Identifier of hosted zone for tools.stockperks.internal."
  default     = "Z04900551C6ZQGWTQQK46"
}

variable "tools_stockperks_internal_hosted_alias_zone_id" {
  type        = string
  description = "Identifier of hosted zone for alias tools.stockperks.internal."
  default     = "Z35SXDOTRQ7X7K"
}

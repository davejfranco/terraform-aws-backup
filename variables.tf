variable "region" {
  type        = string
  description = "value of the region to deploy resources"
  default     = "eu-west-1"
  nullable    = false
}

variable "drp_region" {
  type        = string
  description = "value of the region"
  default     = "eu-central-1"
  nullable    = false
}

variable "vault_name" {
  type        = string
  description = "value of the backup vault name"
  nullable    = false
}

variable "drp_vault_name" {
  type        = string
  description = "value of the backup vault name"
  nullable    = false
}

variable "enable_drp_replication" {
  type        = bool
  description = "enable DRP replication"
  default     = true
}

variable "target_resources_arn" {
  type        = list(string)
  description = "list of ARN of the resources to backup"
  default     = []
  nullable    = false
}

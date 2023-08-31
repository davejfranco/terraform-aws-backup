variable "region" {
  type        = string
  description = "value of the region to deploy resources"
  default     = "eu-west-1" #By default we will deploy in Ireland
  nullable    = false
}

variable "drp_region" {
  type        = string
  description = "value of the region"
  default     = "eu-central-1" #This is hour DRP region
  nullable    = false
}

variable "vault_name" {
  type        = string
  description = "value of the backup vault name"
  nullable    = false
}

variable "rule_name" {
  type        = string
  description = "value of the backup rule name"
  default     = "default-rule"
  nullable    = true
}

variable "target_resources_arn" {
  type        = list(string)
  description = "list of ARN of the resources to backup"
  default     = []
  nullable    = false
}

variable "schedule" {
  type        = string
  description = "value of the backup schedule"
  default     = "cron(0 0 * * ? *)" #every 24 hours
  nullable    = false
}

variable "plan_lifecycle" {
  type = object({
    cold_storage_after = string
    delete_after       = string
  })
  description = "map of the lifecycle of the backup"
  default = {
    cold_storage_after = "30" #90 days
    delete_after       = "90" #3 month
  }
  nullable = false
}

variable "copy_lifecycle" {
  type = object({
    cold_storage_after = string
    delete_after       = string
  })
  description = "map of the copy action of the backup"
  default = {
    cold_storage_after = "30" #90 days
    delete_after       = "90" #3 month
  }
  nullable = false
}
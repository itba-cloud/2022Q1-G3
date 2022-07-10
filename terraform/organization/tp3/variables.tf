variable "name_prefix" {
  description = "Prefix used for creation of multiple buckets with different prefixes (dev helper)"
  type        = string
  default     = ""
}

variable "app_domain_name" {
  description = "App Domain name"
  type        = string
  default     = null
}
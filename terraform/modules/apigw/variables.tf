# ---------------------------------------------------------------------------
# Amazon API Gateway variables
# ---------------------------------------------------------------------------

variable "api_name" {
  type        = string
  description = "The name of the api gateway. Must be less than or equal to 63 characters in length."
}

variable "api_description" {
  type        = string
  description = "The description of the api gateway. Must be less than or equal to 63 characters in length."
  default     = ""
}

variable "api_template" {
  type        = string
  description = "API Template"
}

variable "api_template_vars" {
  type        = map(any)
  description = "API Template Variables for replacement"
}

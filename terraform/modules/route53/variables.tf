# ---------------------------------------------------------------------------
# Amazon Route 53 variables
# ---------------------------------------------------------------------------

variable "app_domain_name" {
  type        = string
  description = "App Domain Name"
}

variable "cloudfront" {
  description = "Cloudfront Distribution for redirection"
}
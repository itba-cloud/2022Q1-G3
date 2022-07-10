# ------------------------------------------------------------------------
# Amazon WAF variables
# ------------------------------------------------------------------------

variable "web_acl_name" {
  type        = string
  description = "The web acl name"
}

variable "web_acl_metrics" {
  type        = string
  description = "The web acl metrics"
}
variable "waf_rule_name" {
  type        = string
  description = "The waf rule name"
}
variable "waf_rule_metrics" {
  type        = string
  description = "The waf rule metrics"
}
variable "waf_rule_group_name" {
  type        = string
  description = "The waf rule group mame"
}
variable "waf_rule_group_metrics" {
  type        = string
  description = "The waf rule group metrics"
}

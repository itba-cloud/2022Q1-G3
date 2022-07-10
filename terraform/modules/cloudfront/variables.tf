# ------------------------------------------------------------------------
# Amazon Cloudfront variables
# ------------------------------------------------------------------------

variable "web_acl_id" {
  type        = string
  description = "WAF ACL ID"
}

variable "s3_domain_name" {
  type        = string
  description = "The domain name of the bucket. Must be less than or equal to 63 characters in length."
}

variable "s3_origin_id" {
  type        = string
  description = "The id of the bucket. Must be less than or equal to 63 characters in length."
}

variable "apigw_domain_name" {
  type        = string
  description = "The name of the apigw domain name . Must be less than or equal to 63 characters in length."
}

variable "apigw_origin_id" {
  type        = string
  description = "The name of the apigw. Must be less than or equal to 63 characters in length." # TODO: Chequear todos estos endpoints
}

variable "apigw_origin_path" {
  type        = string
  description = "The origin path of the apigw"
}

variable "logs_s3_bucket_name" {
  type        = string
  description = "Name of the logs bucket."
  default     = ""
}

variable "logs_prefix" {
  type        = string
  description = "Prefix used for logging."
  default     = ""
}

variable "aliases" {
  type        = list(any)
  description = "List of aliases."
  default     = []
}

variable "certificate_arn" {
  type        = string
  description = "Certificate ARN"
  default     = null
}

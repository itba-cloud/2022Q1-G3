# ---------------------------------------------------------------------------
# Amazon Lambda variables
# ---------------------------------------------------------------------------

variable "aws_region" {
  type        = string
  description = "The AWS region"
}

variable "aws_caller_identity_account_id" {
  type        = string
  description = "the AWS caller identiti account id"
}

variable "api_gateway_id" {
  type        = string
  description = "The API GW ID"
}

variable "api_gateway_execution_arn" {
  type        = string
  description = "The API Gw execution ARN"
}

variable "filename" {
  type        = string
  description = "The lambda filename"
}

variable "source_code_hash" {
  type        = string
  description = "The source code hash"
}

variable "method" {
  type        = string
  description = "The method"
}

variable "name" {
  type        = string
  description = "The fuction name"
}

variable "handler" {
  type        = string
  description = "The handler"
}

variable "runtime" {
  type        = string
  description = "the runtime"
}

variable "path" {
  type        = string
  description = "The path"
}

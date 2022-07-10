# ---------------------------------------------------------------------------
# Amazon Lambda outputs
# ---------------------------------------------------------------------------

output "invoke_arn" {
  value       = aws_lambda_function.this.invoke_arn
  description = "The lambda invoke ARN"
}

output "source_arn" {
  value       = aws_lambda_permission.this.source_arn
  description = "The lambda source ARN"
}

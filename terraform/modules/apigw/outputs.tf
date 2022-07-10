# ---------------------------------------------------------------------------
# Amazon API Gateway outputs
# ---------------------------------------------------------------------------

output "id" {
  description = "The API GW ID"
  value       = aws_api_gateway_rest_api.this.id
}

output "api_endpoint" {
  description = "The API GW enpoint url"
  value       = aws_api_gateway_stage.this.invoke_url
}

output "execution_arn" {
  description = "The API GW execution arn"
  value       = aws_api_gateway_rest_api.this.execution_arn
}

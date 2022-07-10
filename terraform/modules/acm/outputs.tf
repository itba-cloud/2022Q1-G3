# ---------------------------------------------------------------------------
# Amazon AWS Certificate Manager outputs
# ---------------------------------------------------------------------------

output "arn" {
  description = "Certificate ARN"
  value       = aws_acm_certificate.this.arn
}
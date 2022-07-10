# --------------------------------------------------------------------
# Amazon Cloudfront buckets output
# --------------------------------------------------------------------

output "distribution" {
  description = "The cloudfront distribution"
  value       = aws_cloudfront_distribution.this
}

output "access_oai_path" {
  description = "Cloudfront Access OAI Path"
  value       = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
}

output "access_oai" {
  description = "Cloudfront Access OAI"
  value       = aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn
}

output "domain_name" {
  description = "Cloudfront Domain Name"
  value       = aws_cloudfront_distribution.this.domain_name
}
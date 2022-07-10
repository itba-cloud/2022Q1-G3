# ---------------------------------------------------------------------------
# Amazon AWS Certificate Manager datasources
# ---------------------------------------------------------------------------

data "aws_route53_zone" "this" {
  name = var.app_domain_name
}
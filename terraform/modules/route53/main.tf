# ---------------------------------------------------------------------------
# Amazon Route 53 resources
# ---------------------------------------------------------------------------

resource "aws_route53_record" "main" {
  zone_id = data.aws_route53_zone.this.zone_id
  name    = var.app_domain_name
  type    = "A"

  alias {
    name                   = var.cloudfront.domain_name
    zone_id                = var.cloudfront.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.this.zone_id
  name    = "www.${aws_route53_record.main.name}"
  type    = "A"

  alias {
    name                   = aws_route53_record.main.name
    zone_id                = data.aws_route53_zone.this.id
    evaluate_target_health = false
  }
}

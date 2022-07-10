# ---------------------------------------------------------------------------
# Amazon Cloudfront
# ---------------------------------------------------------------------------
resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  # comment = module.s3["website"].id
}

resource "aws_cloudfront_distribution" "this" {
  origin {
    domain_name = var.s3_domain_name
    origin_id   = var.s3_origin_id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
    }
  }

  origin {
    domain_name = var.apigw_domain_name
    origin_id   = var.apigw_origin_id
    origin_path = var.apigw_origin_path

    custom_origin_config {
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
      https_port             = 443
      http_port              = 80
    }
  }

  web_acl_id = var.web_acl_id

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Some comment"
  default_root_object = "index.html"

  # TODO: Habilitar logs de nuevo (funcionaban)
  # logging_config {
  #   include_cookies = false
  #   bucket          = var.logs_s3_bucket_name
  #   prefix          = var.logs_prefix
  # }

  aliases = var.aliases

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = var.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  #   # Cache behavior with precedence 0
  #   ordered_cache_behavior {
  #     path_pattern     = "/content/immutable/*"
  #     allowed_methods  = ["GET", "HEAD", "OPTIONS"]
  #     cached_methods   = ["GET", "HEAD", "OPTIONS"]
  #     target_origin_id = var.origin_s3_bucket_id

  #     forwarded_values {
  #       query_string = false
  #       headers      = ["Origin"]

  #       cookies {
  #         forward = "none"
  #       }
  #     }

  #     min_ttl                = 0
  #     default_ttl            = 86400
  #     max_ttl                = 31536000
  #     compress               = true
  #     viewer_protocol_policy = "redirect-to-https"
  #   }

  #   # Cache behavior with precedence 1
  #   ordered_cache_behavior {
  #     path_pattern     = "/content/*"
  #     allowed_methods  = ["GET", "HEAD", "OPTIONS"]
  #     cached_methods   = ["GET", "HEAD"]
  #     target_origin_id = var.origin_s3_bucket_id

  #     forwarded_values {
  #       query_string = false

  #       cookies {
  #         forward = "none"
  #       }
  #     }

  #     min_ttl                = 0
  #     default_ttl            = 3600
  #     max_ttl                = 86400
  #     compress               = true
  #     viewer_protocol_policy = "redirect-to-https"
  #   }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none"
      #   locations        = ["US", "CA", "GB", "DE", "IN", "IR"]
    }
  }


  tags = {
    service     = "CloudFront"
    version     = "1.0.0"
    environment = "production"
  }

  # [f76f250f] Descomentar cuando haya una hosted zone bajo el dominio: var.app_domain_name y comentar el "viewer_certificate" de abajo
  # viewer_certificate {
  #   acm_certificate_arn      = var.certificate_arn
  #   minimum_protocol_version = "TLSv1.2_2021"
  #   ssl_support_method       = "sni-only"
  # }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

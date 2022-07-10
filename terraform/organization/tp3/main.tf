
# [f76f250f] Descomentar Route 53 y Cerficate Manager cuando haya una hosted zone bajo el dominio: var.app_domain_name
# # ---------------------------------------------------------------------------
# # Amazon Route53
# # ---------------------------------------------------------------------------

# module "route53" {
#   source = "../../modules/route53"

#   app_domain_name = local.app_domain_name
#   cloudfront      = module.cloudfront.distribution
# }

# # ---------------------------------------------------------------------------
# # Amazon AWS Certificate Manager
# # ---------------------------------------------------------------------------

# module "acm" {
#   source = "../../modules/acm"

#   app_domain_name = local.app_domain_name
# }

# ---------------------------------------------------------------------------
# Amazon WAF resources
# ---------------------------------------------------------------------------

module "waf" {
  source = "../../modules/waf"

  providers = {
    aws = aws.aws
  }

  web_acl_name           = local.waf.web_acl_name
  web_acl_metrics        = local.waf.web_acl_metrics
  waf_rule_name          = local.waf.waf_rule_name
  waf_rule_metrics       = local.waf.waf_rule_metrics
  waf_rule_group_name    = local.waf.waf_rule_group_name
  waf_rule_group_metrics = local.waf.waf_rule_group_metrics
}

# ---------------------------------------------------------------------------
# Amazon Cloudfront
# ---------------------------------------------------------------------------

module "cloudfront" {
  source = "../../modules/cloudfront"

  web_acl_id = module.waf.aws_waf_web_acl_id

  s3_domain_name = local.cloudfront.s3_domain_name
  s3_origin_id   = local.cloudfront.s3_origin_id

  apigw_domain_name = local.cloudfront.apigw_domain_name
  apigw_origin_id   = local.cloudfront.apigw_origin_id
  apigw_origin_path = local.cloudfront.apigw_origin_path

  logs_s3_bucket_name = module.s3["logs"].domain_name

  # [f76f250f] Descomentar Route 53 y Cerficate Manager cuando haya una hosted zone bajo el dominio: var.app_domain_name
  # aliases = [
  #   local.app_domain_name,
  #   "www.${local.app_domain_name}"
  # ]
  # certificate_arn = module.acm.arn
}

# ---------------------------------------------------------------------------
# Amazon API Gateway
# ---------------------------------------------------------------------------

module "api_gateway" {
  source = "../../modules/apigw"

  # resource_tag_name = var.resource_tag_name
  # namespace         = var.namespace
  # region            = data.aws_region.current.name

  api_name = local.api_gateway.name
  # api_throttling_rate_limit  = var.api_throttling_rate_limit
  # api_throttling_burst_limit = var.api_throttling_burst_limit
  # api_template               = file(local.openapi.filename)
  api_template = jsonencode({
    openapi = "3.0.1"
    info = {
      title   = "Example"
      version = "1.0"
    }
    paths = {
      # "/users" = {for k, v in module.lambda: 
      #   k => {
      #     x-amazon-apigateway-integration = {
      #       httpMethod           = "POST"
      #       payloadFormatVersion = "1.0"
      #       type                 = "AWS_PROXY"
      #       uri                  = ""
      #     }
      #   }
      # }
      "/hortz" = {
        get = {
          x-amazon-apigateway-integration = {
            httpMethod           = "POST"
            payloadFormatVersion = "1.0"
            type                 = "AWS_PROXY"
            uri                  = module.lambda["hortz"].invoke_arn
          }
        }
      }
      "/users" = {
        # options = {
        #   x-amazon-apigateway-integration = {
        #     httpMethod           = "OPTIONS"
        #     type                 = "mock"
        #     responses            = {
        #       default = {
        #         statusCode = "200"
        #         responseParameters = {
        #           "method.response.header.Content-Type" = "'application/json'"
        #           "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key'"
        #           "method.response.header.Access-Control-Allow-Methods" = "'*'"
        #           "method.response.header.Access-Control-Allow-Origin" = "'*'"
        #         }
        #       }
        #     }
        #   }
        # }
        get = {
          x-amazon-apigateway-integration = {
            httpMethod           = "POST"
            payloadFormatVersion = "1.0"
            type                 = "AWS_PROXY"
            uri                  = module.lambda["getUsers"].invoke_arn
          }
        }
        post = {
          x-amazon-apigateway-integration = {
            httpMethod           = "POST"
            payloadFormatVersion = "1.0"
            type                 = "AWS_PROXY"
            uri                  = module.lambda["createUser"].invoke_arn
          }
        }
      }
    }
  })
  api_template_vars = {
    lambda_getUsers_arn = module.lambda["getUsers"].invoke_arn
    # lambda_invoke_arn = module.lambda["getUsers"].invoke_arn

    # api_name = local.name

    # aws_region = data.aws_region.current.name
    # aws_caller_identity_account_id = data.aws_caller_identity.current.account_id
    # api_gateway_id = module.api_gateway.id


    # cognito_user_pool_arn = module.cognito.cognito_user_pool_arn

    # lambda_identity_arn     = module.identity.lambda_arn
    # lambda_identity_timeout = var.lambda_identity_api_timeout

    # lambda_user_arn     = module.user.lambda_arn
    # lambda_user_timeout = var.lambda_user_api_timeout
  }

}

# ---------------------------------------------------------------------------
# Amazon S3 resources
# ---------------------------------------------------------------------------

module "s3" {
  for_each = local.s3
  source   = "../../modules/s3_4.0"

  bucket_name       = each.value.bucket_name
  bucket_access_oai = [module.cloudfront.access_oai]
  # objects           = try(each.value.objects, {})
  objects_path       = each.value.objects_path
  templated_contents = local.templated_contents[each.key]
}

# resource "aws_s3_object" "this" {
#   provider = aws.aws
#   bucket        = module.s3["website"].id
#   key           = "index.html"
#   content       = data.template_file.index_html.rendered
#   content_type  = "text/html"
#   storage_class = "STANDARD"
# }

# ---------------------------------------------------------------------------
# Amazon VPC
# ---------------------------------------------------------------------------

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = local.vpc.name
  cidr = local.vpc.cidr

  azs              = local.vpc.availability_zones
  public_subnets   = local.vpc.public_subnets
  private_subnets  = local.vpc.private_subnets
  database_subnets = local.vpc.database_subnets

  enable_nat_gateway = false
  enable_vpn_gateway = false

  tags = {
    name        = local.vpc.name
    cidr        = local.vpc.cidr
    version     = "1.0.0"
    environment = "production"
  }
}

# ---------------------------------------------------------------------------
# AWS Lambda
# ---------------------------------------------------------------------------

module "lambda" {
  for_each = local.lambdas_endpoints_iterable

  source = "../../modules/lambda"

  aws_region                     = data.aws_region.current.name
  aws_caller_identity_account_id = data.aws_caller_identity.current.id
  api_gateway_id                 = module.api_gateway.id
  api_gateway_execution_arn      = module.api_gateway.execution_arn

  filename = "${local.lambda.zip_dir}/${local.lambda.zip_prefix}${each.value.name}.zip"
  # source_code_hash               = sha256(filebase64("${local.lambda.zip_dir}/${local.lambda.zip_prefix}${each.value.name}.zip"))
  source_code_hash = data.archive_file.lambda_zip[each.value.name].output_base64sha256
  method           = each.value.method
  path             = each.value.path
  name             = "${local.lambda.name_prefix}${each.value.name}-${local.app_name}"
  handler          = "${each.value.name}.handler"
  runtime          = local.lambda_defaults.runtime
}

# ---------------------------------------------------------------------------
# AWS DynamoDB
# ---------------------------------------------------------------------------

module "dynamodb" {
  source = "../../modules/dynamodb"

  tables = local.dynamodb.tables
}

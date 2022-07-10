locals {
  # Run with env var: export TF_VAR_PREFIX="gabi"
  app_name = "${var.name_prefix}-itba-2022-cloud-g3-tp3"

  app_domain_name = var.app_domain_name

  path = {
    resources = "../../resources"
  }

  vpc = {
    name               = "vpc-${local.app_name}"
    cidr               = "10.0.0.0/16"
    availability_zones = ["${data.aws_region.current.name}a", "${data.aws_region.current.name}b"]
    public_subnets     = ["10.0.1.0/24", "10.0.2.0/24"]
    private_subnets    = ["10.0.11.0/24", "10.0.12.0/24"]
    database_subnets   = ["10.0.21.0/24", "10.0.22.0/24"]
  }


  waf = {
    web_acl_name           = "waf-${local.app_name}"
    web_acl_metrics        = replace("aclmetrics-waf-${local.app_name}", "-", "")
    waf_rule_name          = "rulename-waf-${local.app_name}"
    waf_rule_metrics       = replace("rulemetrics-waf-${local.app_name}", "-", "")
    waf_rule_group_name    = "rulegroupname-waf-${local.app_name}"
    waf_rule_group_metrics = replace("rulegroupmetrics-waf-${local.app_name}", "-", "")
  }

  cloudfront = {
    s3_domain_name    = module.s3["website"].domain_name
    s3_origin_id      = "s3-bucket"
    apigw_domain_name = split("/", module.api_gateway.api_endpoint)[2] # TODO: Está horrible pero funcional
    apigw_origin_id   = split("/", module.api_gateway.api_endpoint)[2]
    apigw_origin_path = "/${split("/", module.api_gateway.api_endpoint)[length(split("/", module.api_gateway.api_endpoint)) - 1]}"
  }

  s3 = {

    # 1 - WWW Website
    www-website = {
      bucket_name  = "www.bucket-s3-${local.app_name}"
      objects_path = "${local.path.resources}/www/"
      templated    = {}
    }

    # 2 - Website
    website = {
      bucket_name  = "bucket-s3-${local.app_name}"
      objects_path = "${local.path.resources}/html/"
      templated = {
        "index.html" : {}
        "js/hortzFile.js" : {}
      }
    }

    # 3 - Logs
    logs = {
      bucket_name  = "logs-bucket-s3-${local.app_name}"
      objects_path = "${local.path.resources}/logs/"
      templated    = {}
    }
  }

  templated_contents = {
    www-website = { for k, v in local.s3.www-website.templated : k => data.template_file.file[k].rendered }
    website     = { for k, v in local.s3.website.templated : k => data.template_file.file[k].rendered }
    logs        = { for k, v in local.s3.logs.templated : k => data.template_file.file[k].rendered }
  }

  openapi = {
    filename = "../../resources/openapi/hortz.yaml"
  }

  api_gateway = {
    name = "api-gw-${local.app_name}"
  }

  lambda_defaults = {
    runtime        = "python3.9"
    file_extension = "py"
  }

  lambda = {
    src_dir    = "${local.path.resources}/lambda/src"
    zip_dir    = "${local.path.resources}/lambda/target"
    zip_prefix = "lamdba-"

    name_prefix = "lambda-"

    lambdas = {
      "/hortz" = {
        GET = "hortz"
      }
      "/users" = {
        GET  = "getUsers"
        POST = "createUser"
      }
    }
  }

  lambda_endpoints = flatten([
    for full_path, value in local.lambda.lambdas : flatten([
      for method, function_name in value : {
        "name"      = function_name
        "filename"  = "${function_name}.${local.lambda_defaults.file_extension}"
        "path"      = trimprefix(full_path, "/")
        "full_path" = full_path
        "method"    = method
      }
    ])
  ])
  lambdas_endpoints_iterable = { for idx, value in local.lambda_endpoints : value.name => value }

  aurora = {
    name = "aurora-rds-${local.app_name}"
    tags = {
      "Name" : "Aurora RDS Serverless PostgreSQL"
    }
  }

  dynamodb_defaults = {
    billing_mode   = "PROVISIONED"
    read_capacity  = "30"
    write_capacity = "30"
  }

  dynamodb = {
    tables = {
      users = {
        billing_mode   = local.dynamodb_defaults.billing_mode
        read_capacity  = local.dynamodb_defaults.read_capacity
        write_capacity = local.dynamodb_defaults.write_capacity
        hash_key       = "userId"
        range_key      = "username"
        attributes = {
          userId   = "S"
          username = "S"
        }
        local_secondary_indexes            = {}
        global_secondary_indexes           = {}
        replica_regions                    = {}
        server_side_encryption_enabled     = false # TODO: activate with a kms key arn
        server_side_encryption_kms_key_arn = null
        tags = {
          version = "1.0.0"
        }
      }
    }
  }

}

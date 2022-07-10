# ---------------------------------------------------------------------------
# Main resources
# ---------------------------------------------------------------------------

# AWS Region
data "aws_region" "current" {
  provider = aws.aws
}

# AWS Caller Identity

data "aws_caller_identity" "current" {
  provider = aws.aws
}

# AWS Lambda ZIP on the fly

data "archive_file" "lambda_zip" {
  for_each = { for idx, value in fileset(local.lambda.src_dir, "*") : replace(value, "/[.].*$/", "") => value }
  # for_each = local.lambdas_endpoints_iterable

  type        = "zip"
  source_file = "${local.lambda.src_dir}/${each.value}"
  output_path = "${local.lambda.zip_dir}/${local.lambda.zip_prefix}${each.key}.zip"
}

# site

## index.html

data "template_file" "file" {
  for_each = local.s3.website.templated
  template = file("${local.path.resources}/html/${each.key}")
  vars = merge(
    each.value,
    {
      API_ENDPOINT = "${module.api_gateway.api_endpoint}"
    }
  )
}
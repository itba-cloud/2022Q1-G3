# ---------------------------------------------------------------------------
# Amazon S3 resources
# ---------------------------------------------------------------------------

module "s3" {
  for_each = local.s3
  source   = "../../modules/s3_4.0"

  bucket_name       = each.value.bucket_name
  bucket_access_oai = [module.cloudfront.access_oai]
  objects           = try(each.value.objects, {})
}

resource "aws_s3_object" "this" {
  provider = aws.aws
  bucket        = module.s3["website"].id
  key           = "index.html"
  content       = data.template_file.userdata.rendered
  content_type  = "text/html"
  storage_class = "STANDARD"
}
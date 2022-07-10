locals {
  mime_types = jsondecode(file("${path.module}/mime.json"))
}
# ------------------------------------------------------------------------------
# Amazon S3
# ------------------------------------------------------------------------------

# 1 - S3 bucket
resource "aws_s3_bucket" "this" {
  bucket              = var.bucket_name
  object_lock_enabled = false

  tags = {
    service = "S3"
    version = "1.0.0"
    name    = var.bucket_name
  }
}

# 2 -Bucket policy
resource "aws_s3_bucket_policy" "this" {
  count = var.objects != {} ? 1 : 0

  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.this.json
}

# 3 -Website configuration
resource "aws_s3_bucket_website_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

# 4 - Access Control List
resource "aws_s3_bucket_acl" "this" {
  bucket = aws_s3_bucket.this.id
  acl    = var.bucket_acl
}

# 5 - Access Block

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# 6 - Upload objects
# resource "aws_s3_object" "this" {
#     for_each =  try(var.objects, {}) #{ for object, key in var.objects: object => key if try(var.objects, {}) != {} }

#     bucket        = aws_s3_bucket.this.id
#     key           = try(each.value.rendered, replace(each.value.filename, "html/", "")) # remote path
#     source        = try(each.value.rendered, format("../../resources/%s", each.value.filename)) # where is the file located
#     content_type  = each.value.content_type
#     storage_class = try(each.value.tier, "STANDARD")
# }

# Non templated
resource "aws_s3_object" "not_templated" {
  for_each      = setsubtract(fileset("${var.objects_path}/", "**"), keys(var.templated_contents))
  bucket        = aws_s3_bucket.this.id
  key           = each.value
  source        = "${var.objects_path}/${each.value}"
  etag          = filemd5("${var.objects_path}/${each.value}")
  storage_class = "STANDARD"
  content_type  = lookup(local.mime_types, regex("\\.[^.]+$", "${var.objects_path}/${each.value}"), null)
}

# Templated
resource "aws_s3_object" "templated" {
  for_each      = var.templated_contents
  bucket        = aws_s3_bucket.this.id
  key           = each.key
  etag          = filemd5("${var.objects_path}/${each.key}")
  storage_class = "STANDARD"
  content       = each.value
  content_type  = lookup(local.mime_types, regex("\\.[^.]+$", "${var.objects_path}/${each.key}"), null)
}

# 7 - Versioning
resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id
  versioning_configuration {
    status = "Enabled"
  }
}

# # 8 - Encription
# resource "aws_kms_key" "mykey" {
#   description             = "This key is used to encrypt bucket objects"
#   deletion_window_in_days = 10
# }

# resource "aws_s3_bucket_server_side_encryption_configuration" "example" {
#   bucket = aws_s3_bucket.this.bucket

#   rule {
#     apply_server_side_encryption_by_default {
#       kms_master_key_id = aws_kms_key.mykey.arn
#       sse_algorithm     = "aws:kms"
#     }
#   }
# }


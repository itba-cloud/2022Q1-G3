# ---------------------------------------------------------------------------
# Amazon S3 datasources
# ---------------------------------------------------------------------------

data "aws_iam_policy_document" "this" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.this.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = var.bucket_access_oai
    }
  }
}
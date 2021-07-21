locals {
  bucket = var.environment != "" ? "${local.root_domain}-${var.environment}" : local.root_domain
}
data "aws_iam_policy_document" "s3_get_policy" {
  statement {
    effect  = "Deny"
    actions = ["s3:*"]

    resources = [
      "arn:aws:s3:::${local.bucket}/*"
    ]
    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = [false]
    }
  }
  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject"
    ]
    resources = [
      "arn:aws:s3:::${local.bucket}/*"
    ]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn]
    }
  }

}

resource "aws_s3_bucket" "bucket" {
  bucket        = local.bucket
  policy        = data.aws_iam_policy_document.s3_get_policy.json
  force_destroy = "true"
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
  cors_rule {
    allowed_headers = var.allowed_headers
    allowed_methods = var.allowed_methods
    allowed_origins = var.allowed_origins
    max_age_seconds = 3000
  }
}

resource "aws_s3_bucket_public_access_block" "bucket" {
  bucket = aws_s3_bucket.bucket.id

  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls  = true
}
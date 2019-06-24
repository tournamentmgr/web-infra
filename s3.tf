locals {
  bucket = "${var.environment != "" ? "${local.root_domain}-${var.environment}" : "${local.root_domain}"}"
}
data "aws_iam_policy_document" "s3_get_policy" {
  statement {
    actions = [
        "s3:GetObject"
    ]
    resources = [
        "arn:aws:s3:::${local.bucket}/*"
    ]

    principals {
      type        = "AWS"
      identifiers = ["${aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn}"]
    }
  }
}

resource "aws_s3_bucket" "bucket" {
  bucket = "${local.bucket}"
  policy = "${data.aws_iam_policy_document.s3_get_policy.json}"
  force_destroy = "true"
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "AES256"
      }
    }
  }
  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = "${var.allowed_methods}"
    allowed_origins = "${var.allowed_origins}"
    max_age_seconds = 3000
  }
}

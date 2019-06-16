resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "${local.root_domain}-${var.environment} Identity"
}

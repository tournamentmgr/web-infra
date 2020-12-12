output "bucket" {
  value = "${aws_s3_bucket.bucket}"
}
output "identity" {
  value = aws_cloudfront_origin_access_identity.origin_access_identity
}

output "distribution" {
  value = aws_cloudfront_distribution.s3_distribution
}
output "route" {
  value = aws_route53_record.domain
}

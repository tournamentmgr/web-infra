output "bucket" {
    value = "${aws_s3_bucket.bucket}"
}
output "identity" {
  value = "${aws_cloudfront_origin_access_identity.origin_access_identity}"
}

output "distribution" {
    value = element(
    concat(
      aws_cloudfront_distribution.s3_distribution,
      aws_cloudfront_distribution.s3_distribution_with_auth,
      aws_cloudfront_distribution.s3_distribution_with_prerender,
      [""],
    ),
    0,
  )
}
output "route" {
    value = "${aws_route53_record.domain}"
}
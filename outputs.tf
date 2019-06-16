output "bucket" {
    value = "${aws_s3_bucket.bucket}"
}
output "distribution" {
    value = element(
    concat(
      aws_cloudfront_distribution.s3_distribution,
      aws_cloudfront_distribution.s3_distribution_with_auth,
      [""],
    ),
    0,
  )
}
output "route" {
    value = "${aws_route53_record.domain}"
}
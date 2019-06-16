resource "aws_route53_record" "domain" {
  zone_id = "${var.zoneid}"
  name = "${var.environment == "" ? "${var.domain}" : "${var.environment}.${var.domain}"}"
  type = "A"
  alias {
    name = element(
    concat(
      aws_cloudfront_distribution.s3_distribution,
      aws_cloudfront_distribution.s3_distribution_with_auth,
      aws_cloudfront_distribution.s3_distribution_with_prerender,
      [""],
    ),
    0,
    ).domain_name
    zone_id =  element(
    concat(
      aws_cloudfront_distribution.s3_distribution,
      aws_cloudfront_distribution.s3_distribution_with_auth,
      aws_cloudfront_distribution.s3_distribution_with_prerender,
      [""],
    ),
    0,
    ).hosted_zone_id
    evaluate_target_health = false
  }
}
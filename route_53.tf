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
resource "aws_route53_record" "cname" {
  count = var.environment == "" ? 1 : 0
  zone_id = "${var.zoneid}"
  name    = "www"
  type    = "CNAME"
  ttl     = "5"
  records = [var.domain]
}

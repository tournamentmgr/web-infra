resource "aws_route53_record" "domain" {
  count   = var.zone_id != "" ? 1 : 0
  zone_id = var.zoneid
  name    = var.environment == "" ? "${var.domain}" : "${var.environment}.${var.domain}"
  type    = "A"
  alias {
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}

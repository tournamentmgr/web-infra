resource "aws_cloudfront_distribution" "s3_distribution_with_prerender" {
  count = "${var.enable_prerender == true && var.basic_auth == false ? 1 : 0}"
  origin {
    domain_name = "${aws_s3_bucket.bucket.bucket_regional_domain_name}"
    origin_id = "${aws_s3_bucket.bucket.id}"

    s3_origin_config {
      origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
    }
  }

  enabled = true
  is_ipv6_enabled = true
  default_root_object = "index.html"

  aliases = ["${var.environment == "" ? "${var.domain}" : "${var.environment}.${var.domain}"}"]

  default_cache_behavior {
    allowed_methods = "${var.allowed_methods}"
    cached_methods  = "${var.allowed_methods}"
    target_origin_id = "${aws_s3_bucket.bucket.id}"
    
    forwarded_values {
      query_string = true

      cookies {
        forward = "none"
      } 
      headers = ["user-agent", "Origin", "Access-Control-Request-Headers", "Access-Control-Request-Method"]
    }
    lambda_function_association {
      event_type = "origin-response"
      lambda_arn = "${aws_lambda_function.hsts_protection.arn}:${aws_lambda_function.hsts_protection.version}"
    }
    lambda_function_association {
      event_type = "origin-request"
      lambda_arn = "${aws_lambda_function.prerender.0.arn}:${aws_lambda_function.prerender.0.version}"
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl = 0
    default_ttl = 3600
    max_ttl = 86400
  }

  tags = {
    Environment = "${var.environment}"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  viewer_certificate {
    acm_certificate_arn = "arn:aws:acm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:certificate/${var.certificate_id}"
    ssl_support_method = "sni-only"
  }
  custom_error_response {
    error_code = 404
    response_code = 200
    response_page_path = "/index.html"
  }
  custom_error_response {
    error_code = 403
    response_code = 200
    response_page_path = "/index.html"
  }
}
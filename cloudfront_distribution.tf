data "aws_cloudfront_origin_request_policy" "personalized_manifest" {
  name = "Managed-Elemental-MediaTailor-PersonalizedManifests"
}
data "aws_cloudfront_cache_policy" "cache_disabled" {
  name = "Managed-CachingDisabled"
}

resource "aws_cloudfront_response_headers_policy" "this" {
  name = (var.environment == "") ? replace(var.domain, ".", "_") : var.environment
  security_headers_config {
    content_type_options {
      override = true
    }
    frame_options {
      frame_option = "DENY"
      override     = true
    }
    referrer_policy {
      referrer_policy = "same-origin"
      override        = true
    }
    strict_transport_security {
      access_control_max_age_sec = 63072000
      include_subdomains         = true
      preload                    = true
      override                   = true
    }
    xss_protection {
      protection = true
      mode_block = true
      override   = true
    }
  }

}
resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = aws_s3_bucket.this.bucket_regional_domain_name
    origin_id   = aws_s3_bucket.this.id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  aliases = (var.environment == "") ? [var.domain] : ["${var.environment}.${var.domain}"]


  default_cache_behavior {
    allowed_methods            = var.allowed_methods
    cached_methods             = var.allowed_methods
    target_origin_id           = aws_s3_bucket.this.id
    compress                   = true
    origin_request_policy_id   = data.aws_cloudfront_origin_request_policy.personalized_manifest.id
    cache_policy_id            = data.aws_cloudfront_cache_policy.cache_disabled.id
    response_headers_policy_id = aws_cloudfront_response_headers_policy.this.id

    dynamic "function_association" {
      for_each = var.basic_auth ? [1] : []
      content {
        event_type   = "viewer-request"
        function_arn = aws_cloudfront_function.auth.0.arn
      }
    }
    dynamic "function_association" {
      for_each = var.basic_auth ? [] : (var.index_redirect ? [1] : [])
      content {
        event_type   = "viewer-request"
        function_arn = aws_cloudfront_function.index_redirect.0.arn
      }
    }
    dynamic "lambda_function_association" {
      for_each = var.enable_prerender ? [1] : []
      content {
        event_type = "origin-request"
        lambda_arn = "${aws_lambda_function.prerender.0.arn}:${aws_lambda_function.prerender.0.version}"
      }
    }


    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0
  }

  tags = {
    Environment = var.environment
  }

  restrictions {
    dynamic "geo_restriction" {
      for_each = length(var.region_denylist) > 0 ? [1] : []
      content {
        restriction_type = "blacklist"
        locations        = var.region_denylist
      }
    }
    dynamic "geo_restriction" {
      for_each = length(var.region_denylist) > 0 ? [] : [1]
      content {
        restriction_type = "none"
      }
    }
  }
  viewer_certificate {
    acm_certificate_arn      = "arn:aws:acm:us-east-1:${data.aws_caller_identity.current.account_id}:certificate/${var.certificate_id}"
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  dynamic "custom_error_response" {
    for_each = var.custom_error_responses
    content {
      error_caching_min_ttl = 300
      error_code            = custom_error_response.value.error_code
      response_code         = custom_error_response.value.response_code
      response_page_path    = custom_error_response.value.response_page_path
    }
  }
}

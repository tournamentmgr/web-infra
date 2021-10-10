data "template_file" "auth" {
  template = file("${path.module}/templates/password.tmpl")
  vars = {
    username       = var.username
    password       = var.password
    index_redirect = var.index_redirect
  }
}

data "template_file" "prerender" {
  template = file("${path.module}/templates/prerender.tmpl")
  vars = {
    prerenderBucket = var.prerender_bucket
  }
}

resource "aws_cloudfront_function" "auth" {
  count   = var.basic_auth ? 1 : 0
  name    = "basic_auth_${var.environment}"
  runtime = "cloudfront-js-1.0"
  publish = true
  code    = data.template_file.auth.rendered
}

resource "aws_cloudfront_function" "hsts_protection" {
  name    = var.environment == "" ? "hsts_protection" : "hsts_protection_${var.environment}"
  runtime = "cloudfront-js-1.0"
  publish = true
  code    = file("${path.module}/functions/hsts.js")
}

resource "aws_cloudfront_function" "index_redirect" {
  count   = var.index_redirect ? 1 : 0
  name    = var.environment == "" ? "index_redirect" : "index_redirect_${var.environment}"
  runtime = "cloudfront-js-1.0"
  publish = true
  code    = file("${path.module}/functions/index_redirect.js")
}

resource "aws_cloudfront_function" "prerender" {
  count   = var.enable_prerender ? 1 : 0
  code    = data.template_file.prerender.rendered
  name    = var.environment == "" ? "prerender" : "prerender_${var.environment}"
  runtime = "cloudfront-js-1.0"
  publish = true
}

data "template_file" "auth" {
  template = file("${path.module}/templates/password.tmpl")
  vars = {
    username       = var.username
    password       = var.password
    index_redirect = var.index_redirect
  }
}
resource "aws_cloudfront_function" "auth" {
  count   = var.basic_auth ? 1 : 0
  name    = "basic_auth_${var.environment}"
  runtime = "cloudfront-js-1.0"
  publish = true
  code    = data.template_file.auth.rendered
}

resource "aws_cloudfront_function" "index_redirect" {
  count   = var.index_redirect ? 1 : 0
  name    = var.environment == "" ? "index_redirect" : "index_redirect_${var.environment}"
  runtime = "cloudfront-js-1.0"
  publish = true
  code    = file("${path.module}/functions/index_redirect.js")
}

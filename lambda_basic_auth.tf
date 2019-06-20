data "template_file" "init" {
  template = "${file("${path.module}/templates/password.tmpl")}"
  vars = {
    username = "${var.username}"
    password = "${var.password}"
  }
}
data "archive_file" "auth_zip" {
  type        = "zip"
  output_path = "${path.module}/password.zip"

  source {
    content  = "${data.template_file.init.rendered}"
    filename = "lambda.js"
  }
}
resource "aws_lambda_function" "auth" {
  count            = "${var.basic_auth ? 1 : 0}"
  filename         = "${path.module}/password.zip"
  function_name    = "basic_auth_${var.environment}"
  role             = "${aws_iam_role.lambda_at_edge_role.arn}"
  handler          = "lambda.handler"
  runtime          = "nodejs10.x"
  source_code_hash = "${data.archive_file.auth_zip.output_base64sha256}"
  publish          = "true"
}
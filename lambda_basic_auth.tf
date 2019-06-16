data "template_file" "init" {
  template = "${file("${path.module}/templates/password.tmpl")}"
  vars = {
    username = "${var.username}"
    password = "${var.password}"
  }
}
resource "local_file" "password" {
    content     = "${data.template_file.init.rendered}"
    filename    = "${path.module}/functions/password/password.js"
}
data "archive_file" "auth_zip" {
    type        = "zip"
    source_dir  = "${path.module}/functions/password"
    output_path = "${path.module}/password.zip"
    depends_on  = ["local_file.password"]
}
resource "aws_lambda_function" "auth" {
  count            = "${var.basic_auth ? 1 : 0}"
  depends_on       = ["local_file.password"]
  filename         = "${path.module}/password.zip"
  function_name    = "basic_auth_${var.environment}"
  role             = "${aws_iam_role.lambda_at_edge_policy.arn}"
  handler          = "password.handler"
  runtime          = "nodejs10.x"
  source_code_hash = "${data.archive_file.auth_zip.output_base64sha256}"
  publish          = "true"
}
data "template_file" "prerender" {
  template = "${file("${path.module}/templates/prerender.tmpl")}"
  vars = {
    prerenderBucket = "${var.prerender_bucket}"
  }
}
resource "local_file" "prerender" {
    content     = "${data.template_file.prerender.rendered}"
    filename    = "${path.module}/functions/prerender/prerender.js"
}
data "archive_file" "prerender_zip" {
    type        = "zip"
    source_dir  = "${path.module}/functions/prerender"
    output_path = "${path.module}/prerender.zip"
    depends_on  = ["local_file.prerender"]
}
resource "aws_lambda_function" "prerender" {
  count            = "${var.enable_prerender ? 1 : 0}"
  depends_on       = ["local_file.prerender"]
  filename         = "${path.module}/prerender.zip"
  function_name    = "prerender_${var.environment}"
  role             = "${aws_iam_role.lambda_at_edge_role.arn}"
  handler          = "prerender.handler"
  runtime          = "nodejs10.x"
  source_code_hash = "${data.archive_file.prerender_zip.output_base64sha256}"
  publish          = "true"
}
data "archive_file" "hsts_zip" {
  type        = "zip"
  source_dir  = "${path.module}/functions/hsts"
  output_path = "${path.module}/hsts.zip"
}

resource "aws_lambda_function" "hsts_protection" {
  filename         = "${path.module}/hsts.zip"
  function_name    = var.environment == "" ? "hsts_protection" : "hsts_protection_${var.environment}"
  role             = aws_iam_role.lambda_at_edge_role.arn
  handler          = "hsts.handler"
  runtime          = "nodejs10.x"
  source_code_hash = data.archive_file.hsts_zip.output_base64sha256
  publish          = "true"
}

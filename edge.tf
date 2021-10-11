resource "aws_iam_role" "lambda_at_edge_role" {
  name               = var.environment == "" ? "lambdaEdgeRole" : "lambdaEdgeRole_${var.environment}"
  assume_role_policy = <<EOF
 {
   "Version": "2012-10-17",
   "Statement": [
     {
       "Sid": "",
       "Effect": "Allow",
       "Principal": {
         "Service": [
           "lambda.amazonaws.com",
           "edgelambda.amazonaws.com"
         ]
       },
       "Action": "sts:AssumeRole"
     }
   ]
 }
 EOF
}
data "template_file" "prerender" {
  template = file("${path.module}/templates/prerender.tmpl")
  vars = {
    prerenderBucket = var.prerender_bucket
  }
}
data "archive_file" "prerender_zip" {
  type        = "zip"
  output_path = "${path.module}/prerender.zip"

  source {
    content  = data.template_file.prerender.rendered
    filename = "lambda.js"
  }
}
resource "aws_lambda_function" "prerender" {
  count            = var.enable_prerender ? 1 : 0
  filename         = "${path.module}/prerender.zip"
  function_name    = var.environment == "" ? "prerender" : "prerender_${var.environment}"
  role             = aws_iam_role.lambda_at_edge_role.arn
  handler          = "lambda.handler"
  runtime          = "nodejs14.x"
  source_code_hash = data.archive_file.prerender_zip.output_base64sha256
  publish          = "true"
}

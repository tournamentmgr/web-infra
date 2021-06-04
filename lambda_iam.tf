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


resource "aws_iam_policy" "lambda_at_edge_policy" {
  name   = var.environment == "" ? "LogPolicy_" : "LogPolicy_${var.environment}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}
resource "aws_iam_role_policy_attachment" "log-attach" {
  count      = var.enable_logging ? 1 : 0
  role       = aws_iam_role.lambda_at_edge_role.name
  policy_arn = aws_iam_policy.lambda_at_edge_policy.arn
}

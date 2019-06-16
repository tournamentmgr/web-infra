data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
locals {
  root_domain = "${element(split(".", "${var.domain}"), 0)}"
}

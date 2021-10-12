# SPA Infrastructure
The following modules allow for simple to provision single page application environments. The following resources are provisioned:
- Cloudfront Functions HTTP Strict Transport Security
- Cloudfront Functions Basic Auth (optional)
- Private S3 Bucket with SSE AES256
- Cloudfront distribution with OIA read access to bucket
- Route 53 DNS entry

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | n/a |
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_template"></a> [template](#provider\_template) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudfront_distribution.s3_distribution](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution) | resource |
| [aws_cloudfront_function.auth](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_function) | resource |
| [aws_cloudfront_function.hsts_protection](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_function) | resource |
| [aws_cloudfront_function.index_redirect](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_function) | resource |
| [aws_cloudfront_origin_access_identity.origin_access_identity](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_origin_access_identity) | resource |
| [aws_iam_role.lambda_at_edge_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_lambda_function.prerender](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_route53_record.domain](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_s3_bucket.bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_public_access_block.bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [archive_file.prerender_zip](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.edge](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.s3_get_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [template_file.auth](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.prerender](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allowed_headers"></a> [allowed\_headers](#input\_allowed\_headers) | Allowed Methods | `list` | <pre>[<br>  "*"<br>]</pre> | no |
| <a name="input_allowed_methods"></a> [allowed\_methods](#input\_allowed\_methods) | Allowed Methods | `list` | <pre>[<br>  "GET",<br>  "HEAD"<br>]</pre> | no |
| <a name="input_allowed_origins"></a> [allowed\_origins](#input\_allowed\_origins) | Allowed Headers | `list` | <pre>[<br>  "*"<br>]</pre> | no |
| <a name="input_basic_auth"></a> [basic\_auth](#input\_basic\_auth) | Enable basic auth | `bool` | `false` | no |
| <a name="input_certificate_id"></a> [certificate\_id](#input\_certificate\_id) | Certificate ID | `any` | n/a | yes |
| <a name="input_custom_error_responses"></a> [custom\_error\_responses](#input\_custom\_error\_responses) | Error Responses within cloudfront | <pre>list(object({<br>    error_code         = number,<br>    response_code      = number,<br>    response_page_path = string<br>  }))</pre> | <pre>[<br>  {<br>    "error_code": 404,<br>    "response_code": 200,<br>    "response_page_path": "/index.html"<br>  },<br>  {<br>    "error_code": 403,<br>    "response_code": 200,<br>    "response_page_path": "/index.html"<br>  }<br>]</pre> | no |
| <a name="input_domain"></a> [domain](#input\_domain) | the domain you want to deploy to | `any` | n/a | yes |
| <a name="input_enable_prerender"></a> [enable\_prerender](#input\_enable\_prerender) | Enable SEO Prerender bucket routing | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | the subdomain environment you want to deploy to. If domain is naked, do not specify | `string` | `""` | no |
| <a name="input_index_redirect"></a> [index\_redirect](#input\_index\_redirect) | Enable index redirect https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/example-function-add-index.html | `bool` | `false` | no |
| <a name="input_password"></a> [password](#input\_password) | the password to utilize for the domain | `string` | `""` | no |
| <a name="input_prerender_bucket"></a> [prerender\_bucket](#input\_prerender\_bucket) | Prerender Bucket name | `string` | `""` | no |
| <a name="input_username"></a> [username](#input\_username) | the username to utilize for the domain | `string` | `""` | no |
| <a name="input_zoneid"></a> [zoneid](#input\_zoneid) | route53 zone id | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket"></a> [bucket](#output\_bucket) | n/a |
| <a name="output_distribution"></a> [distribution](#output\_distribution) | n/a |
| <a name="output_identity"></a> [identity](#output\_identity) | n/a |
| <a name="output_route"></a> [route](#output\_route) | n/a |

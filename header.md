# SPA Infrastructure
The following modules allow for simple to provision single page application environments. The following resources are provisioned:
- Cloudfront Functions HTTP Strict Transport Security
- Cloudfront Functions Basic Auth (optional)
- Private S3 Bucket with SSE AES256
- Cloudfront distribution with OIA read access to bucket
- Route 53 DNS entry

## Migrate to v2
- S3 bucket resource renamed to this from bucket: `terraform state mv module.x.aws_s3_bucket.bucket module.x.aws_s3_bucket.this`
- Import needed `terraform import module.x.aws_s3_bucket_server_side_encryption_configuration.this <bucket name>`
- Import needed `terraform import module.x.aws_s3_bucket_cors_rule.this <bucket name>`

# SPA Infrastructure
The following modules allow for simple to provision single page application environments. The following resources are provisioned:
- Lambda@Edge HTTP Strict Transport Security
- Lambda@Edge Basic Auth (optional)
- Private S3 Bucket with SSE AES256
- Cloudfront distribution with OIA read access to bucket
- Route 53 DNS entry

### Module Documentation:
Variables:
---
- environment (optional) - the subdomain environment you want to deploy to. If domain is naked, do not specify.
- basic_auth (optional) - boolean to enable basic auth w/lambda@Edge
- username - username for lambda@Edge, if basic_auth
- password - password for lambda@Edge, if basic_auth
- enable_prerender (optional) - boolean to enable prerender routing: https://dev.to/danquack/caching-spas-for-seo-with-lamdbaedge-24ba
- prerender_bucket - s3 bucket to route prerender traffic to
- domain - the domain you want to deploy to
- zoneid - route53 zone id
- certificate_id - Certificate ID from ACM

Outputs
---
- bucket - the bucket to use for data
- distribution - cloudfront distibution
- route - newly created A record
- identity - cloudfront identity

### Example
```
provider "aws" {
  version = "~> 2.13.0"
  region = "us-east-1"
}

module "example" {
    source = "github.com/danquack/web-infra"
    environment = "example"
    domain = "domain.com"
    zoneid = "<Zone ID from AWS>"
    certificate_id = "<Certificate ID from AWS>"
}
```
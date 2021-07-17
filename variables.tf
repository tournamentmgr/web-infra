variable "environment" {
  description = "the subdomain environment you want to deploy to. If domain is naked, do not specify"
  default     = ""
}
variable "domain" {
  description = "the domain you want to deploy to"
}

variable "zoneid" {
  description = "route53 zone id"
}
variable "certificate_id" {
  description = "Certificate ID"
}

variable "basic_auth" {
  description = "Enable basic auth"
  default     = false
}
variable "username" {
  description = "the username to utilize for the domain"
  default     = ""
}
variable "password" {
  description = "the password to utilize for the domain"
  default     = ""
}
variable "enable_prerender" {
  description = "Enable SEO Prerender bucket routing"
  default     = false
}
variable "prerender_bucket" {
  description = "Prerender Bucket name"
  default     = ""
}
variable "allowed_origins" {
  description = "Allowed Headers"
  default     = ["*"]
}
variable "allowed_methods" {
  description = "Allowed Methods"
  default     = ["GET", "HEAD"]
}
variable "allowed_headers" {
  description = "Allowed Methods"
  default     = ["*"]
}
variable "enable_logging" {
  description = "Enable logging IAM permissions"
  default     = true
}
variable "custom_error_responses" {
  description = "Error Responses within cloudfront"
  type = list(object({
    error_code         = number,
    response_code      = number,
    response_page_path = string
  }))
  default = [{
    error_code         = 404
    response_code      = 200
    response_page_path = "/index.html"
    }, {
    error_code         = 403
    response_code      = 200
    response_page_path = "/index.html"
  }]
}
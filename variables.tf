variable "environment" {
    description = "the subdomain environment you want to deploy to. If domain is naked, do not specify"
    default = ""
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
    default = false
}
variable "username" {
    description = "the username to utilize for the domain"
    default = ""
}
variable "password" {
    description = "the password to utilize for the domain"
    default = ""
}
variable "enable_prerender" {
    description = "Enable SEO Prerender bucket routing"
    default = false
}
variable "prerender_bucket" {
    description = "Prerender Bucket name"
    default = ""
}

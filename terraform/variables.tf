variable "s3_static_website" {}
variable "domain_name" {}
variable "aws_region" {
  type    = string
  default = "ap-south-1"
}

variable "cloudflare_email" {}
variable "cloudflare_api_token" {}
variable "cloudflare_zone_name" {}
variable "cloudflare_sub_domain_name" {}

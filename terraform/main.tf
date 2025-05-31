data "aws_cloudfront_cache_policy" "this" {
  name = "Managed-CachingOptimized"
}

data "aws_acm_certificate" "this" {
  provider    = aws.us_east_1
  domain      = var.domain_name
  statuses    = ["ISSUED"]
  most_recent = true
}

// creating s3 bucket for hosting static website
module "s3_static_website" {
  source        = "./modules/s3"
  bucket_name   = var.s3_static_website
  force_destroy = true
  # index_document     = "index.html"
  frontend_directory = "frontend"
}


# module "certificate" {
#   source                    = "./modules/acm"
#   certificate_domain        = var.certificate_domain
#   subject_alternative_names = ["www.${var.certificate_domain}"]
# }

module "cloudfront" {
  source              = "./modules/cloudfront"
  domain_name         = var.domain_name
  cache_policy_id     = data.aws_cloudfront_cache_policy.this.id
  acm_certificate_arn = data.aws_acm_certificate.this.arn
  cdn_domain_name     = module.s3_static_website.bucket_regional_domain_name
  depends_on          = [module.s3_static_website]
}

# module "route53" {
#   source                    = "./modules/route53"
#   domain_name               = var.domain_name
#   domain_validation_options = module.certificate.domain_validation_options
#   certificate_arn           = module.certificate.cert-arn
# }


# module "alias" {
#   source                 = "./modules/alias"
#   domain_name            = var.domain_name
#   certificate_domain     = var.certificate_domain
#   cloudfront_domain_name = module.cloudfront.cloudfront_domain_name
#   cloudfront-zone-id     = module.cloudfront.cloudfront_hosted-zone_id
#   depends_on             = [module.cloudfront]
# }

module "s3_permission" {
  source                      = "./modules/permission"
  bucket_id                   = module.s3_static_website.bucket_id
  bucket_arn                  = module.s3_static_website.bucket_arn
  cloudfront_distribution_arn = module.cloudfront.cloudfront-arn
  depends_on                  = [module.cloudfront, module.s3_static_website]

}


module "cloudflare_record" {
  source                     = "./modules/cloudflare"
  cloudflare_zone_id         = var.cloudflare_zone_id
  cloudflare_sub_domain_name = var.cloudflare_sub_domain_name
  cloudflare_record_content  = module.cloudfront.cloudfront_domain_name
  depends_on                 = [module.cloudfront]


}

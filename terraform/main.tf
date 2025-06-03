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
  source                 = "./modules/s3"
  bucket_name            = var.domain_name
  force_destroy          = true
  enable_logging         = true
  logging_bucket_id      = module.s3_static_website_logging.bucket_id
  enable_website_hosting = true
  # block_public_acls       = true
  # block_public_policy     = true
  # ignore_public_acls      = true
  # restrict_public_buckets = true
  # index_document     = "index.html"
  # frontend_directory = "frontend"
}

# // create logging bucket for website
# module "s3_static_website_logging" {
#   source            = "./modules/s3"
#   bucket_name       = "${var.domain_name}-logging"
#   force_destroy     = true
#   enable_encryption = false
# }

# // create logging bucket for cloudfront
# module "s3_cloudfront_logging" {
#   source            = "./modules/s3"
#   bucket_name       = "fileshare-cloudfront-logging"
#   force_destroy     = true
#   enable_encryption = false
# }


module "s3_website_configuration" {
  source    = "./modules/s3Website"
  bucket_id = module.s3_static_website.bucket_id

}


module "s3_static_website_object" {
  source             = "./modules/s3Object"
  bucket_id          = module.s3_static_website.bucket_id
  frontend_directory = "frontend"
}




//create bucket_acl for logging

# module "s3_logging_acl" {
#   source     = "./modules/acl"
#   bucket_id  = module.s3_static_website_logging.bucket_id
#   bucket_acl = "log-delivery-write"
# }



//create bucket_acl for logging
# module "s3_cloudfront_logging_acl" {
#   source     = "./modules/acl"
#   bucket_id  = module.s3_cloudfront_logging.bucket_id
#   bucket_acl = "log-delivery-write"
# }



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
  cdn_domain_name     = module.s3_website_configuration.website_endpoint
  log_bucket_name     = module.s3_cloudfront_logging.bucket_name
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

# module "s3_permission" {
#   source      = "./modules/permission"
#   bucket_name = module.s3_static_website.bucket_name
#   bucket_arn  = module.s3_static_website.bucket_arn
#   # cloudfront_distribution_arn= module.cloudfront.cloudfront_arn
#   cloudfront_distribution_id = module.cloudfront.cloudfront_distribution_id
#   depends_on                 = [module.cloudfront, module.s3_static_website]

# }


module "cloudflare_record" {
  source                     = "./modules/cloudflare"
  cloudflare_zone_id         = var.cloudflare_zone_id
  cloudflare_sub_domain_name = var.cloudflare_sub_domain_name
  cloudflare_record_content  = module.cloudfront.cloudfront_domain_name
  depends_on                 = [module.cloudfront]


}

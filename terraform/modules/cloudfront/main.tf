# locals {
#   log_bucket_domain_name = "${var.log_bucket_name}.s3.amazonaws.com"
# }



# resource "aws_cloudfront_origin_access_control" "assign-oac" {
#   name                              = var.oac-name
#   description                       = "An origin access control with s3 origin domain for cloudfront"
#   origin_access_control_origin_type = var.origin_access_control_origin_type
#   signing_behavior                  = var.signing_behavior
#   signing_protocol                  = var.signing_protocol
# }


resource "aws_cloudfront_distribution" "cdn" {
  origin {
    domain_name = var.cdn_domain_name
    origin_id   = var.cdn_origin_id
    # origin_access_control_id = aws_cloudfront_origin_access_control.assign-oac.id
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only" # Static hosting only supports HTTP
      origin_ssl_protocols   = ["TLSv1.2"]
    }

  }

  default_cache_behavior {
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = var.cdn_origin_id
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400


    cache_policy_id          = var.cache_policy_id
    origin_request_policy_id = aws_cloudfront_origin_request_policy.this.id
  }



  # logging_config {
  #   bucket          = local.log_bucket_domain_name
  #   include_cookies = false
  #   prefix          = "cloudfront-logs/"
  # }


  restrictions {
    geo_restriction {
      restriction_type = var.restriction_type
    }
  }

  viewer_certificate {
    acm_certificate_arn            = var.acm_certificate_arn
    ssl_support_method             = "sni-only"
    minimum_protocol_version       = "TLSv1.2_2021"
    cloudfront_default_certificate = false
  }



  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = var.default_root_object
  aliases             = [var.domain_name, "www.${var.domain_name}"]
}


resource "aws_cloudfront_origin_request_policy" "this" {
  name = "ForwardQueryOnly"

  cookies_config {
    cookie_behavior = "none"
  }

  headers_config {
    header_behavior = "allViewer"
  }

  query_strings_config {
    query_string_behavior = "all"
  }
}


resource "null_resource" "cloudfront_invalidation" {
  triggers = {
    always_run = timestamp()
  }


  provisioner "local-exec" {
    command = <<EOT
      aws cloudfront create-invalidation \
        --distribution-id ${aws_cloudfront_distribution.cdn.id} \
        --paths "/*"
    EOT
  }

  depends_on = [aws_cloudfront_distribution.cdn]
}

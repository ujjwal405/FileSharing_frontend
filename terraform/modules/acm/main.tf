resource "aws_acm_certificate" "this" {
  domain_name               = var.certificate_domain
  validation_method         = var.validation_method
  subject_alternative_names = var.subject_alternative_names

  # Ensure that the resource is rebuilt before destruction when running an update
  lifecycle {
    create_before_destroy = true
  }
}

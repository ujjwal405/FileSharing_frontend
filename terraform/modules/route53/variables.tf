
variable "domain_name" {
  description = "This is the name of the hosted zone."
  type        = string
}

variable "domain_validation_options" {
  description = "The domain validation options from the ACM certificate."
  type = list(object({
    domain_name           = string
    resource_record_name  = string
    resource_record_type  = string
    resource_record_value = string
  }))
}

variable "certificate_arn" {
  type = string
}

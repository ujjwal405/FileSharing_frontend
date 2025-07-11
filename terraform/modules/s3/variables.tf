variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}


variable "force_destroy" {
  description = "Whether to allow bucket deletion even if it has objects"
  type        = bool
  default     = false
}




variable "block_public_acls" {
  type    = bool
  default = false
}


variable "block_public_policy" {
  type    = bool
  default = false
}


variable "ignore_public_acls" {
  type    = bool
  default = false
}


variable "restrict_public_buckets" {
  type    = bool
  default = false
}




# variable "index_document" {
#   description = "The index document for the static website (can be empty)"
#   type        = string
#   default     = "index.html"
# }

# variable "error_document" {
#   description = "The error document for the static website (can be empty)"
#   type        = string
#   default     = ""
# }




# variable "frontend_directory" {}

variable "enable_encryption" {
  description = "Whether to enable SSE encryption on the S3 bucket"
  type        = bool
  default     = true
}

variable "logging_bucket_id" {
  default = null
}

variable "enable_logging" {
  type    = bool
  default = false
}


variable "enable_website_hosting" {
  type    = bool
  default = false
}

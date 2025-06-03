variable "bucket_id" {}


variable "index_document" {
  description = "The index document for the static website (can be empty)"
  type        = string
  default     = "index.html"
}

variable "error_document" {
  description = "The error document for the static website (can be empty)"
  type        = string
  default     = ""
}

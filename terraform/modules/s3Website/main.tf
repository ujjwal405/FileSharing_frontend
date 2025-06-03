resource "aws_s3_bucket_website_configuration" "this" {
  bucket = var.bucket_id

  index_document {
    suffix = var.index_document
  }

  error_document {
    key = var.error_document
  }
}

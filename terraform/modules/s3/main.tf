
resource "aws_s3_bucket" "this" {
  bucket        = var.bucket_name
  force_destroy = var.force_destroy
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  count  = var.enable_encryption ? 1 : 0
  bucket = aws_s3_bucket.this.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}


resource "aws_s3_bucket_ownership_controls" "this" {
  bucket = aws_s3_bucket.this.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}



resource "aws_s3_bucket_public_access_block" "this" {
  bucket                  = aws_s3_bucket.this.id
  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets
}


resource "aws_s3_bucket_logging" "this" {
  count  = var.enable_logging ? 1 : 0
  bucket = aws_s3_bucket.this.id

  target_bucket = var.logging_bucket_id
  target_prefix = "logs/"
}


# resource "aws_s3_bucket_website_configuration" "this" {
#   count  = var.enable_website_hosting ? 1 : 0
#   bucket = aws_s3_bucket.this.id

#   index_document {
#     suffix = var.index_document
#   }

#   error_document {
#     key = var.error_document
#   }
# }


# resource "aws_s3_object" "this" {
#   for_each = fileset("${path.module}/../../../${var.frontend_directory}", "*.html") # Match only .html files

#   bucket       = aws_s3_bucket.this.id
#   key          = each.value                                                        # Key in S3 (filename)
#   source       = "${path.module}/../../../${var.frontend_directory}/${each.value}" # Local file path (using path.module)
#   content_type = lookup(local.mime_types, split(".", each.value)[1], "binary/octet-stream")

# }


resource "aws_s3_bucket_policy" "this" {
  count  = var.enable_website_hosting ? 1 : 0
  bucket = aws_s3_bucket.this.bucket
  policy = jsonencode({
    Version = "2012-10-17"
    "Statement" : [
      {
        "Sid" : "PublicReadGetObject",
        "Effect" : "Allow",
        "Principal" : "*",
        "Action" : "s3:GetObject",
        "Resource" : "${aws_s3_bucket.this.arn}/*"
      }
    ]
  })
}




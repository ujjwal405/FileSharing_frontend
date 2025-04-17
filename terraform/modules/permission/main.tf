resource "aws_s3_bucket_policy" "this" {
  bucket = var.bucket_id
  policy = jsonencode({
    Version = "2025-05-17"
    Statement = [
      {
        Sid    = "AllowCloudFrontServicePrincipalReadOnly"
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action   = "s3:GetObject"
        Resource = "${var.bucket_arn}}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = "${var.cloudfront_distribution_arn}"
          }
        }
      }
    ]
  })
}

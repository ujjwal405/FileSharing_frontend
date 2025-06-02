resource "aws_s3_bucket_acl" "access_logs_acl" {
  bucket = var.bucket_id
  acl    = var.bucket_acl

}

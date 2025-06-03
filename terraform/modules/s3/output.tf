output "bucket_arn" {
  description = "The ARN of the S3 bucket"
  value       = aws_s3_bucket.this.arn
  sensitive   = true
}

output "bucket_id" {
  value     = aws_s3_bucket.this.id
  sensitive = true
}

output "bucket_regional_domain_name" {
  description = "This is the bucket domain name including the region name."
  value       = aws_s3_bucket.this.bucket_regional_domain_name
  sensitive   = true
}

# output "bucket_domain_name" {
#   value     = aws_s3_bucket.this.bucket_domain_name
#   sensitive = true
# }

output "bucket_name" {
  value = aws_s3_bucket.this.bucket
}

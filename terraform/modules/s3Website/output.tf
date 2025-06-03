output "website_endpoint" {
  description = "This is the bucket domain name including the region name."
  value       = aws_s3_bucket_website_configuration.this.website_endpoint
  sensitive   = true
}

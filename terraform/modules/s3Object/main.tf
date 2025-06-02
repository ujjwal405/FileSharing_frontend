locals {
  mime_types = {
    html = "text/html"
    css  = "text/css"
    js   = "application/javascript"
    png  = "image/png"
    jpg  = "image/jpeg"
    svg  = "image/svg+xml"
  }
}



resource "aws_s3_object" "this" {
  for_each = fileset("${path.module}/../../../${var.frontend_directory}", "*.html") # Match only .html files

  bucket       = var.bucket_id
  key          = each.value                                                        # Key in S3 (filename)
  source       = "${path.module}/../../../${var.frontend_directory}/${each.value}" # Local file path (using path.module)
  content_type = lookup(local.mime_types, split(".", each.value)[1], "binary/octet-stream")

}

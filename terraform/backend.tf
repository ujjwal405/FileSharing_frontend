terraform {
  backend "s3" {
    bucket       = "filesharing-terraform-backend"
    key          = "prod/fileSharing-frontend/terraform.tfstate"
    region       = "ap-south-1"
    encrypt      = true
    use_lockfile = true #S3 native locking
  }
}

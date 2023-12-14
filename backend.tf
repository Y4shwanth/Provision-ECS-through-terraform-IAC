
terraform {
  backend "s3" {
    bucket  = "bucket_name"
    key     = "key_name"
    region  = "region_name"
    encrypt = "true"
  }
}


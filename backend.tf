terraform {
  backend "s3" {
    bucket  = "my-bucket"
    key     = "global/s3/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}
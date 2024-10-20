terraform {
  backend "s3" {
    key     = "global/s3/terraform.tfstate"
    encrypt = true
  }
}
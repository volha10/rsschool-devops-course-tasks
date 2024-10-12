resource "aws_s3_bucket" "sample_bucket" {
  bucket = var.aws_sample_bucket_name

  tags = {
    app = "rsschl"
  }
}
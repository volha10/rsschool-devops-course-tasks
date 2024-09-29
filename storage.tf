resource "aws_s3_bucket" "task_1_bucket" {
  bucket = "task-1-my-bucket"

  tags = {
    app = "rsschl"
  }
}
# resource "aws_ecr_repository" "web_app" {
#   name = "python-k8s-app"
#
#   image_tag_mutability = "MUTABLE"
#   encryption_configuration {
#     encryption_type = "AES256"
#   }
#
#   tags = {
#     App = "rsschl"
#   }
#
# }

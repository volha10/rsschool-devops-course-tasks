resource "aws_iam_role" "github_action_role" {
  name = "GithubActionRoleNew"
  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Principal" : {
            "Federated" : "arn:aws:iam::123456123456:oidc-provider/token.actions.githubusercontent.com"
          },
          "Action" : "sts:AssumeRoleWithWebIdentity",
          "Condition" : {
            "StringLike" : {
              "token.actions.githubusercontent.com:sub" : "repo:volha10/rsschool-devops-course-tasks:*"
            },
            "StringEquals" : {
              "token.actions.githubusercontent.com:aud" : "sts.amazonaws.com"
            }
          }
        }
      ]
    }

  )

  tags = {
    app = "rsschl"
  }
}


resource "aws_iam_role_policy_attachment" "attach_policies" {
  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonEC2FullAccess",
    "arn:aws:iam::aws:policy/AmazonRoute53FullAccess",
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/IAMFullAccess",
    "arn:aws:iam::aws:policy/AmazonVPCFullAccess",
    "arn:aws:iam::aws:policy/AmazonSQSFullAccess",
    "arn:aws:iam::aws:policy/AmazonEventBridgeFullAccess"
  ])
  role       = aws_iam_role.github_action_role.name
  policy_arn = each.value

}
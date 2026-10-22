# Allow my manually configured iamadmin user to see the billing info

/*
resource "aws_iam_user_policy_attachment" "billing" {
  provider   = aws.eu-west-1
  user       = "iamadmin"
  policy_arn = "arn:aws:iam::aws:policy/job-function/Billing"
}

  
resource "aws_iam_user" "iamuser" {
  name = "iamuser"
  provider = aws.eu-west-1
}


resource "aws_iam_group" "iamgroup" {
  name = "iamgroup"
  provider = aws.eu-west-1
}

resource "aws_iam_group_membership" "team" {
  name = "iam-membership"
  provider = aws.eu-west-1
  users = [
    aws_iam_user.iamuser.name,
  ]
  group = aws_iam_group.iamgroup.name
}

resource "aws_iam_user_policy" "userpolicy" {
  name = "userpolicy-inline"
  provider = aws.eu-west-1
  user = aws_iam_user.iamuser.name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:Describe*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}


resource "aws_iam_group_policy" "grouppolicy" {
  name  = "grouppolicy-inline"
  provider = aws.eu-west-1
  group = aws_iam_group.iamgroup.name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:Describe*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_policy" "policy" {
  name        = "iampolicy"
  provider = aws.eu-west-1
  path        = "/"
  description = "My iam policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:Describe*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}


resource "aws_iam_group_policy_attachment" "attach" {
  group      = aws_iam_group.iamgroup.name
  provider = aws.eu-west-1
  policy_arn = aws_iam_policy.policy.arn
}
resource "aws_iam_user_policy_attachment" "attach" {
  user       = aws_iam_user.iamuser.name
  provider = aws.eu-west-1
  policy_arn = aws_iam_policy.policy.arn
}
*/
### THis will create the organization on AWS and enable the root access features for managing root credentials and sessions.

resource "aws_organizations_organization" "org" {
  provider = aws.eu-west-1
  aws_service_access_principals = [
    "cloudtrail.amazonaws.com",
    "config.amazonaws.com",
    "iam.amazonaws.com",
  ]

  feature_set = "ALL"
}


resource "aws_iam_organizations_features" "root_access" {
  provider = aws.eu-west-1
  enabled_features = [
    "RootCredentialsManagement",
    "RootSessions",
  ]
  depends_on = [aws_organizations_organization.org]
}




resource "aws_iam_user_policy" "assume_member_roles" {
  provider = aws.eu-west-1
  name     = "assume-organization-account-access"
  user ="iamadmin"
#user     = "lrozehnal"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = "sts:AssumeRole"
      Resource = "arn:aws:iam::*:role/OrganizationAccountAccessRole"
    }]
  })
}



## Let me create three accounts 'blue' 'green' and 'red' for testing purposes. I will create the accounts in the 'eu-west-1' region.

resource "aws_organizations_account" "mplexia-blue" {
  provider = aws.eu-west-1
  name      = "mplexia-blue"
  email     = "l.rozehnal+mplexia-blue@mplexia.com"
  role_name = "OrganizationAccountAccessRole"
}

resource "aws_organizations_account" "mplexia-green" {
  provider = aws.eu-west-1
  name      = "mplexia-green"
  email     = "l.rozehnal+mplexia-green@mplexia.com"
  role_name = "OrganizationAccountAccessRole"
}

resource "aws_organizations_account" "mplexia-red" {
  provider = aws.eu-west-1
  name      = "mplexia-red"
  email     = "l.rozehnal+mplexia-red@mplexia.com"
  role_name = "OrganizationAccountAccessRole"
}



### TESTING THE RESOURCES

resource "aws_s3_bucket" "red" {
  provider = aws.mplexia-red-eu-west-1
  bucket   = "mplexia-red-eu-west-1-bucket"
}

resource "aws_s3_bucket" "green" {
  provider = aws.mplexia-green-eu-west-1
  bucket   = "mplexia-green-eu-west-1-bucket"
}

resource "aws_s3_bucket" "blue" {
  provider = aws.mplexia-blue-eu-west-1
  bucket   = "mplexia-blue-eu-west-1-bucket"
}

/*
*/


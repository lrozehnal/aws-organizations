resource "aws_organizations_organizational_unit" "security" {
  provider  = aws.eu-west-1
  name      = "Security"
  parent_id = aws_organizations_organization.org.roots[0].id
}

resource "aws_organizations_account" "log_archive" {
  provider  = aws.eu-west-1
  name      = "Log-Archive"
  email     = "l.rozehnal+log-archive@mplexia.com"
  role_name = "OrganizationAccountAccessRole"
  parent_id = aws_organizations_organizational_unit.security.id
}

resource "aws_organizations_account" "audit" {
  provider  = aws.eu-west-1
  name      = "Audit"
  email     = "l.rozehnal+audit@mplexia.com"
  role_name = "OrganizationAccountAccessRole"
  parent_id = aws_organizations_organizational_unit.security.id
}



resource "aws_iam_role" "controltower_admin" {
  provider = aws.eu-west-1
  name     = "AWSControlTowerAdmin"
  path     = "/service-role/"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "controltower.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "controltower_admin" {
  provider = aws.eu-west-1
  name     = "AWSControlTowerAdminPolicy"
  role     = aws_iam_role.controltower_admin.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = "ec2:DescribeAvailabilityZones"
      Resource = "*"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "controltower_admin" {
  provider   = aws.eu-west-1
  role       = aws_iam_role.controltower_admin.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSControlTowerServiceRolePolicy"
}


resource "aws_iam_role" "controltower_cloudtrail" {
  provider = aws.eu-west-1
  name     = "AWSControlTowerCloudTrailRole"
  path     = "/service-role/"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "cloudtrail.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "controltower_cloudtrail" {
  provider   = aws.eu-west-1
  role       = aws_iam_role.controltower_cloudtrail.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSControlTowerCloudTrailRolePolicy"
}



resource "aws_controltower_landing_zone" "tower_LZ" {
  provider = aws.eu-west-1
  version  = "4.0"

  manifest_json = jsonencode({
    governedRegions = ["eu-west-1"]

    centralizedLogging = {
      enabled   = true
      accountId = aws_organizations_account.log_archive.id
      configurations = {
        loggingBucket       = { retentionDays = 365 }
        accessLoggingBucket = { retentionDays = 365 }
      }
    }

    securityRoles = {
      enabled   = true
      accountId = aws_organizations_account.audit.id
    }

    config = {
      enabled   = true
      accountId = aws_organizations_account.audit.id
    }

    accessManagement = {
      enabled = false
    }

    backup = {
      enabled = false
    }
  })

  timeouts {
    create = "120m"
    update = "120m"
    delete = "120m"
  }
}
/*
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
  close_on_deletion = true
}

resource "aws_organizations_account" "audit" {
  provider  = aws.eu-west-1
  name      = "Audit"
  email     = "l.rozehnal+audit@mplexia.com"
  role_name = "OrganizationAccountAccessRole"
  parent_id = aws_organizations_organizational_unit.security.id
  close_on_deletion = true
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


resource "aws_iam_role" "controltower_stackset" {
  provider = aws.eu-west-1
  name     = "AWSControlTowerStackSetRole-TF"
  path     = "/service-role/"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "cloudformation.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}


resource "aws_iam_role_policy" "controltower_stackset" {
  provider = aws.eu-west-1
  name     = "AssumeExecutionRole"
  role     = aws_iam_role.controltower_stackset.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = "sts:AssumeRole"
      Resource = "arn:aws:iam::*:role/AWSControlTowerExecution"
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
      configurations = {
        loggingBucket       = { retentionDays = 365 }
        accessLoggingBucket = { retentionDays = 365 }
  }
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



resource "aws_iam_role" "controltower_execution-red" {
  provider = aws.mplexia-red-eu-west-1
  name     = "AWSControlTowerExecution"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { AWS = "arn:aws:iam::159596244804:root" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "controltower_execution-red" {
  provider   = aws.mplexia-red-eu-west-1
  role       = aws_iam_role.controltower_execution-red.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}



resource "aws_iam_role" "controltower_execution-blue" {
  provider = aws.mplexia-blue-eu-west-1
  name     = "AWSControlTowerExecution"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { AWS = "arn:aws:iam::159596244804:root" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "controltower_execution-blue" {
  provider   = aws.mplexia-blue-eu-west-1
  role       = aws_iam_role.controltower_execution-blue.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}



resource "aws_iam_role" "controltower_execution-green" {
  provider = aws.mplexia-green-eu-west-1
  name     = "AWSControlTowerExecution"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { AWS = "arn:aws:iam::159596244804:root" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "controltower_execution-green" {
  provider   = aws.mplexia-green-eu-west-1
  role       = aws_iam_role.controltower_execution-blue.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}



resource "aws_controltower_baseline" "red" {
  provider = aws.eu-west-1

  baseline_identifier = "arn:aws:controltower:eu-west-1::baseline/17BSJV3IGJ2QSGA2"
  baseline_version    = "5.0"
  target_identifier   = aws_organizations_organizational_unit.red.arn

  depends_on = [aws_iam_role.controltower_execution-red]
}


resource "aws_controltower_baseline" "bluegreen" {
  provider = aws.eu-west-1

  baseline_identifier = "arn:aws:controltower:eu-west-1::baseline/17BSJV3IGJ2QSGA2"
  baseline_version    = "5.0"
  target_identifier   = aws_organizations_organizational_unit.bluegreen.arn

  depends_on = [aws_iam_role.controltower_execution-green, aws_iam_role.controltower_execution-blue]
}


resource "aws_controltower_baseline" "green" {
  provider = aws.eu-west-1

  baseline_identifier = "arn:aws:controltower:eu-west-1::baseline/17BSJV3IGJ2QSGA2"
  baseline_version    = "5.0"
  target_identifier   = aws_organizations_organizational_unit.green.arn

  depends_on = [aws_iam_role.controltower_execution-green, aws_iam_role.controltower_execution-blue]
}



resource "aws_controltower_baseline" "blue" {
  provider = aws.eu-west-1

  baseline_identifier = "arn:aws:controltower:eu-west-1::baseline/17BSJV3IGJ2QSGA2"
  baseline_version    = "5.0"
  target_identifier   = aws_organizations_organizational_unit.blue.arn

  depends_on = [aws_iam_role.controltower_execution-green, aws_iam_role.controltower_execution-blue]
}



/*

resource "aws_controltower_baseline" "blue" {
  provider = aws.eu-west-1

  baseline_identifier = "arn:aws:controltower:eu-west-1::baseline/17BSJV3IGJ2QSGA2"
  baseline_version    = "5.0"
  target_identifier   = aws_organizations_organizational_unit.blue.arn

  depends_on = [aws_iam_role.controltower_execution-blue]
}

resource "aws_controltower_baseline" "green" {
  provider = aws.eu-west-1

  baseline_identifier = "arn:aws:controltower:eu-west-1::baseline/17BSJV3IGJ2QSGA2"
  baseline_version    = "5.0"
  target_identifier   = aws_organizations_organizational_unit.green.arn

  depends_on = [aws_iam_role.controltower_execution-green]
}

*/



/*

resource "aws_organizations_organizational_unit" "sandbox" {
  provider  = aws.eu-west-1
  name      = "Sandbox"
  parent_id = aws_organizations_organization.org.roots[0].id
}

resource "aws_controltower_baseline" "sandbox" {
  provider = aws.eu-west-1

  baseline_identifier = "arn:aws:controltower:eu-west-1::baseline/17BSJV3IGJ2QSGA2"
  baseline_version    = "5.0"
  target_identifier   = aws_organizations_organizational_unit.sandbox.arn

  depends_on = [
    aws_iam_role.controltower_execution-red,
    aws_iam_role.controltower_execution-blue,
    aws_iam_role.controltower_execution-green,
  ]
}
*/
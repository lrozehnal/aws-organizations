### THis will create the organization on AWS and enable the root access features for managing root credentials and sessions.

resource "aws_organizations_organization" "org" {
  provider = aws.eu-west-1
  aws_service_access_principals = [
    "cloudtrail.amazonaws.com",
    "config.amazonaws.com",
    "iam.amazonaws.com",
  ]

  feature_set = "ALL"
  enabled_policy_types = [
    "SERVICE_CONTROL_POLICY",
  ]
}


resource "aws_iam_organizations_features" "root_access" {
  provider = aws.eu-west-1
  enabled_features = [
    "RootCredentialsManagement",
    "RootSessions",
  ]
  depends_on = [aws_organizations_organization.org]
}




resource "aws_iam_user_policy" "assume_AccessRole" {
  provider = aws.eu-west-1
  name     = "AssumeRole"
  user ="iamadmin"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = "sts:AssumeRole"
      Resource = "arn:aws:iam::*:role/AccessRole"
    }]
  })
}

resource "aws_organizations_organizational_unit" "bluegreen" {
  name      = "Blue_and_Green"
  provider = aws.eu-west-1
  parent_id = aws_organizations_organization.org.roots[0].id
}


resource "aws_organizations_organizational_unit" "blue" {
  name      = "Blue"
  provider = aws.eu-west-1
  parent_id = aws_organizations_organizational_unit.bluegreen.id
}

resource "aws_organizations_organizational_unit" "green" {
  name      = "Green"
  provider = aws.eu-west-1
  parent_id = aws_organizations_organizational_unit.bluegreen.id
}

resource "aws_organizations_organizational_unit" "red" {
  name      = "Red"
  provider = aws.eu-west-1
  parent_id = aws_organizations_organization.org.roots[0].id
}







data "aws_iam_policy_document" "AllowAll" {
  statement {
    effect    = "Allow"
    actions   = ["*"]
    resources = ["*"]
  }
}

resource "aws_organizations_policy" "PolicyAllowAll" {
  name    = "AllowAll"
  provider = aws.eu-west-1
  content = data.aws_iam_policy_document.AllowAll.json
}


resource "aws_organizations_policy_attachment" "red_policy_attach" {
  provider = aws.eu-west-1
  policy_id = aws_organizations_policy.PolicyAllowAll.id
  target_id = aws_organizations_organizational_unit.red.id
}



## Let me create  another three AWS accounts 'blue' 'green' and 'red' for testing purposes. I will create the accounts in the 'eu-west-1' region.



resource "aws_organizations_account" "mplexia-blue" {
  provider = aws.eu-west-1
  name      = "mplexia-blue"
  email     = "l.rozehnal+mplexiablue@mplexia.com"
  role_name = "AssumeRole"
  parent_id = aws_organizations_organizational_unit.blue.id 
}

resource "aws_organizations_account" "mplexia-green" {
  provider = aws.eu-west-1
  name      = "mplexia-green"
  email     = "l.rozehnal+mplexiagreen@mplexia.com"
  role_name = "AssumeRole"
  parent_id = aws_organizations_organizational_unit.green.id 
}

resource "aws_organizations_account" "mplexia-red" {
  provider = aws.eu-west-1
  name      = "mplexia-red"
  email     = "l.rozehnal+mplexiared@mplexia.com"
  role_name = "AssumeRole"
  parent_id = aws_organizations_organizational_unit.red.id 
}



### TESTING THE RESOURCES


resource "aws_s3_bucket" "red" {
  provider = aws.mplexia-red-eu-west-1
  bucket   = "mplexia-red-eu-west-1-test-bucket"
}



resource "aws_s3_bucket" "green" {
  provider = aws.mplexia-green-eu-west-1
  bucket   = "mplexia-green-eu-west-1-test-bucket"
}

resource "aws_s3_bucket" "blue" {
  provider = aws.mplexia-blue-eu-west-1
  bucket   = "mplexia-blue-eu-west-1-test-bucket"
}



/**/


### FOLLOWING IS NEEDED IN ORDER TO ALLOW THIS IF THE ACCOUNT IS INVITED (I GUESS)


/*
data "aws_caller_identity" "current" {
    provider = aws.eu-west-1
} 


resource "aws_iam_role" "org_access_red" {
  provider = aws.mplexia-red-eu-west-1
  name = "AccessRoleGUI"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = { AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"}
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role" "org_access_green" {
  provider = aws.mplexia-green-eu-west-1
  name = "AccessRoleGUI"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = { AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"}
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role" "org_access_blue" {
  provider = aws.mplexia-blue-eu-west-1
  name = "AccessRoleGUI"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = { AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"}
      Action = "sts:AssumeRole"
    }]
  })
}

 resource "aws_iam_role_policy_attachment" "admin_red" {                                                                                                                                                                                                                                                                        
   provider   = aws.mplexia-red-eu-west-1                                                                                                                                                                                                                                                                                   
   role       = "AccessRoleGUI"                                                                                                                                                                                                                                                                                             
   policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"                                                                                                                                                                                                                                                               
 }      

 resource "aws_iam_role_policy_attachment" "admin_green" {                                                                                                                                                                                                                                                                        
   provider   = aws.mplexia-green-eu-west-1                                                                                                                                                                                                                                                                                   
   role       = "AccessRoleGUI"                                                                                                                                                                                                                                                                                             
   policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"                                                                                                                                                                                                                                                               
 }      

 resource "aws_iam_role_policy_attachment" "admin_blue" {                                                                                                                                                                                                                                                                        
   provider   = aws.mplexia-blue-eu-west-1                                                                                                                                                                                                                                                                                   
   role       = "AccessRoleGUI"                                                                                                                                                                                                                                                                                             
   policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"                                                                                                                                                                                                                                                               
 }      



*/

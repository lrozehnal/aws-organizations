terraform {
  required_providers {
    aws = {}
  }
  backend "s3" {
    bucket       = "ludek-terraform-states-buckets"
    key          = "aws-organizations/terraform.tfstate"
    region       = "eu-west-1"
    use_lockfile = true
    encrypt      = true
  }
}

provider "aws" {
  alias   = "eu-west-1"
  region  = "eu-west-1"
  profile = "mplexia-root"
}

provider "aws" {
  alias   = "eu-west-2"
  region  = "eu-west-2"
  profile = "mplexia-root"
}


provider "aws" {
  alias   = "us-east-1"
  region  = "us-east-1"
  profile = "mplexia-root"
}


provider "aws" {
  alias   = "us-east-2"
  region  = "us-east-2"
  profile = "mplexia-root"
}


provider "aws" {
  alias   = "us-west-2"
  region  = "us-west-2"
  profile = "mplexia-root"
}

provider "aws" {
  alias   = "us-west-1"
  region  = "us-west-1"
  profile = "mplexia-root"
}

provider "aws" {
  alias   = "ap-southeast-1"
  region  = "ap-southeast-1"
  profile = "mplexia-root"
}

provider "aws" {
  alias   = "ap-northeast-1"
  region  = "ap-northeast-1"
  profile = "mplexia-root"
}

### FOLLOWING ARE ADDITIOANL PROVIDERS ADDED FOR THE PURPOSE OF CREATING THE ORGANIZATION AND ACCOUNTS IN MULTIPLE REGIONS.

provider "aws" {
  alias   = "mplexia-red-eu-west-1"
  region  = "eu-west-1"
  profile = "mplexia-root"
  assume_role {
    role_arn = "arn:aws:iam::${aws_organizations_account.mplexia-red.id}:role/AssumeRole"
  }
}

provider "aws" {
  alias   = "mplexia-blue-eu-west-1"
  region  = "eu-west-1"
  profile = "mplexia-root"
  assume_role {
    role_arn = "arn:aws:iam::${aws_organizations_account.mplexia-blue.id}:role/AssumeRole"
  }
}

provider "aws" {
  alias   = "mplexia-green-eu-west-1"
  region  = "eu-west-1"
  profile = "mplexia-root"
  assume_role {
    role_arn = "arn:aws:iam::${aws_organizations_account.mplexia-green.id}:role/AssumeRole"
  }
}

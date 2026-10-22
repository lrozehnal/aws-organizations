/*

resource "aws_s3_bucket" "ec2bucket" {
  provider = aws.eu-west-2
  bucket   = "ec2bucket-${data.aws_caller_identity.current.account_id}" 

}

resource "aws_s3_bucket_public_access_block" "ec2bucket" {
  provider = aws.eu-west-2
  bucket   = aws_s3_bucket.ec2bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


resource "aws_iam_role" "ec2-role-allow-s3" {
  name = "ec2-role-allow-s3"
  provider = aws.eu-west-2  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy" "ec2-role-allow-s3-policy" {
  name = "ec2-access-to-s3"
  provider = aws.eu-west-2
  role = aws_iam_role.ec2-role-allow-s3.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:ListAllMyBuckets",
          "s3:GetBucketLocation"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket",
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = [
          aws_s3_bucket.ec2bucket.arn,
          "${aws_s3_bucket.ec2bucket.arn}/*"
        ]
      }
    ]
  })
}

### FOLLOWING IS PART OF EC2 - IT CAN'T BE EASILY ACCESSED - AS FAR AS I KNOW - FROM THE MENU, ONLY DURING EC2 CREATION?? 

resource "aws_iam_instance_profile" "ec2-role-allow-s3-profile" {
  name = "ec2-role-allow-s3-profile"
  provider = aws.eu-west-2
  role = aws_iam_role.ec2-role-allow-s3.name
}


*/
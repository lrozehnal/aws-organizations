/*
resource "aws_cloudformation_stack" "cf_s3_role" {
  name          = "cf-s3-role-stack"
  provider      = aws.eu-west-1
  template_body = file("../cf-templates/cf-s3-role.yaml")

  parameters = {
    BucketName = "cf-s3-bucket"
  }

  capabilities = ["CAPABILITY_NAMED_IAM"]

  tags = {
    ManagedBy = "Terraform"
  }
}

output "bucket_name" {
  value = aws_cloudformation_stack.cf_s3_role.outputs["BucketName"]
}

output "role_name" {
  value = aws_cloudformation_stack.cf_s3_role.outputs["RoleName"]
}

output "role_arn" {
  value = aws_cloudformation_stack.cf_s3_role.outputs["RoleARN"]
}
*/
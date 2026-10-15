data "aws_caller_identity" "current" {
    provider = aws.eu-west-1
} 

resource "aws_iam_role" "access_red_with_external_id" {
  provider = aws.mplexia-red-eu-west-1
  name = "AssumeRole_with_external_ID"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = { AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"}
      Action = "sts:AssumeRole"
      Condition = {
        StringEquals = {
          "sts:ExternalId" = "MyExternalID"
        }
      }
    }]
  })
}


 resource "aws_iam_role_policy_attachment" "admin_red_external_id" {                                                                                                                                                                                                                                                                        
   provider   = aws.mplexia-red-eu-west-1                                                                                                                                                                                                                                                                                   
   role       = "AssumeRole_with_external_ID"
   policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"                                                                                                                                                                                                                                                               
 } 

 ## HOW TO USE IT VIA CLI

 #  aws sts assume-role --profile=mplexia-root  --role-arn arn:aws:iam::206632867607:role/AssumeRole_with_external_ID --role-session-name MySession --external-id "MyExternalID" 
 # note: 206632867607 is my red account ,  (to be found here: " terraform state show aws_organizations_account.mplexia-red | grep id " )
 # note: I need to use correct aws profile (the mplexia-root)

 ## Further more I would get AccessKeyId, SecretAccessKey and SessionToken in the output of the above command and then I would use them to configure my aws cli as below
 ## As a single liner, I would look something like:

 # AWS_ACCESS_KEY_ID="deleted" AWS_SECRET_ACCESS_KEY="deleted" AWS_SESSION_TOKEN="deleted"  aws sts get-caller-identity  --profile=mplexia-root
 #  





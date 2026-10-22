locals {
  aws_config_env = yamldecode(file("../config/config.yaml"))
  OUs            = local.aws_config_env.OUs
  tags = {
    terraform = "yes"
    github    = "https://github.com/lrozehnal/aws-organizations"
  }
}

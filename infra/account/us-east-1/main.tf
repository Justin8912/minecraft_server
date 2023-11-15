module "minecraft-server" {
  source = "../../modules/ec2"

  app_name = local.app_name
  account_name = "${local.account_id}-${local.region}"
  public-connection-key = local.public-connection-key
  minecraft-iam-role-name = module.IAM.minecraft-iam-role-name
}

module "IAM" {
  source = "../../modules/IAM"

  app-name = local.app_name
}

module "application-lambda" {
  source = "../../modules/lambda"
  minecraft-server-iam-role-arn = module.IAM.minecraft-iam-role-arn
}
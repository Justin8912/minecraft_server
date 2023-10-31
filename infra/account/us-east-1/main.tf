module "minecraft-server" {
  source = "../../modules/ec2"

  app_name = local.app_name
  account_name = "${local.account_id}-${local.region}"
  public-connection-key = local.public-connection-key
}
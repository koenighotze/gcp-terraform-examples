module "webserver" {
  depends_on = [module.network]
  source     = "./modules/webserver"

  zone          = var.zone
  name_postfix  = local.name_postfix
  mig_pool_size = var.mig_pool_size

  firewall_target_tags     = local.firewall_target_tags
  instance_subnetwork_name = module.network.instance_subnetwork_name
  vpc_name                 = module.network.vpc_name

  website_bucket_url             = module.website.website_bucket_url
  instance_service_account_email = google_service_account.instance_service_account.email
}

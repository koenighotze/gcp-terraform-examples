module "webserver" {
  source = "./modules/webserver"

  zone          = var.zone
  name_postfix  = local.name_postfix
  mig_pool_size = var.mig_pool_size

  firewall_target_tags = local.firewall_target_tags
  subnet_name          = google_compute_subnetwork.instance_subnetwork.name
  vpc_name             = google_compute_network.vpc.name

  website_bucket_url             = module.website.website_bucket_url
  instance_service_account_email = google_service_account.instance_service_account.email
}

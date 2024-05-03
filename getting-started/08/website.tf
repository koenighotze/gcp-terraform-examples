module "website" {
  source = "./modules/website"

  region                         = var.region
  instance_service_account_email = google_service_account.instance_service_account.email
  website_bucket_name            = "website"
}

module "getting-started-03" {
  source = "./getting-started/03"

  project_id = var.project_id
  region     = var.region
  zone       = var.zone
  sa_email   = var.sa_email
}

locals {
  project      = "ex-08"
  name_postfix = "${local.project}-${random_integer.integer.result}"

  firewall_target_tags = ["webserver"]

  website_bucket_name = lower("website-${local.name_postfix}")
  website_content = [
    "index.html",
    "404.html"
  ]

  default_labels = {
    purpose        = "gcp-terraform-training"
    gettingstarted = local.name_postfix
    owner          = "koenighotze"
    environment    = "dev"
    project        = local.project
    git_sha        = var.git_sha
  }
}

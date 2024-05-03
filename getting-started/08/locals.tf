locals {
  project      = "ex-08"
  name_postfix = "${local.project}-${random_integer.integer.result}"

  firewall_target_tags = ["webserver"]

  default_labels = {
    purpose        = "gcp-terraform-training"
    gettingstarted = local.name_postfix
    owner          = "koenighotze"
    environment    = "dev"
    project        = local.project
    git_sha        = var.git_sha
  }
}

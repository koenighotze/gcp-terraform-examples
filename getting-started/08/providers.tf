provider "google" {
  project = var.project_id
  region  = var.region

  default_labels = merge(local.default_labels, var.extra_labels)
}

provider "random" {
}

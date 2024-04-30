provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone

  default_labels = {
    purpose        = "gcp-terraform-training"
    gettingstarted = "05"
    git_sha        = var.git_sha
  }
}

provider "random" {
}

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone

  default_labels = {
    purpose = "gcp-terraform-training"
    target  = "ex-03"
  }
}

provider "google-beta" {
  project = "my-project-id"
  region  = var.region
  zone    = var.zone

  default_labels = {
    purpose = "gcp-terraform-training"
    target  = "ex-03"
  }
}



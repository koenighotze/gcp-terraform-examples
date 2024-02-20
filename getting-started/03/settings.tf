terraform {
  required_version = "~> 1.7.0"

  backend "gcs" {
    # bucket = pass on cli
    prefix = "terraform/gcp-training/state"
  }

  required_providers {
    google = {
      version = "~> 5.0.0"
    }
    google-beta = {
      version = "~> 5.0.0"
    }
  }
}

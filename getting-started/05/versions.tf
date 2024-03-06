terraform {
  required_version = "~> 1.7.0"

  backend "gcs" {
    # bucket = pass on cli
    prefix = "terraform/gcp-training/getting-started/04/state"
  }

  required_providers {
    google = {
      version = "~> 5"
      source  = "hashicorp/google"
    }
  }
}

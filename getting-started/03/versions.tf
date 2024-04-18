terraform {
  required_version = "~> 1.8.0"

  backend "gcs" {
    # bucket = pass on cli
    prefix = "terraform/gcp-training/getting-started/03/state"
  }

  required_providers {
    google = {
      version = "~> 5.0.0"
      source  = "hashicorp/google"
    }
  }
}

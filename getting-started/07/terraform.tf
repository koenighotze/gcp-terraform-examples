terraform {
  required_version = "~> 1.7.0"

  backend "gcs" {
    # bucket = pass on cli
    prefix = "terraform/gcp-training/getting-started/07/state"
  }

  required_providers {
    google = {
      version = "~> 5.0"
      source  = "hashicorp/google"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6.0"
    }
  }
}

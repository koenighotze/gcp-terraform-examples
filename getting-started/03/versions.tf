terraform {
  required_version = "~> 1.7.0"
  required_providers {
    google = {
      version = "~> 5.0.0"
      source  = "hashicorp/google"
    }
  }
}

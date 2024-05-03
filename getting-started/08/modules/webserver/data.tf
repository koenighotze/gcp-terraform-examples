data "google_compute_image" "image" {
  family  = var.image_family
  project = var.image_project
}

data "google_compute_machine_types" "machine_types" {
  filter = "name = \"${var.machine_type_name}\""
  zone   = var.zone
}

data "google_compute_subnetwork" "instance_subnetwork" {
  name = var.instance_subnetwork_name
}

data "google_compute_network" "vpc" {
  name = var.vpc_name
}

data "google_compute_zones" "available" {
}

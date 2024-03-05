data "google_compute_image" "image" {
  family  = "debian-12"
  project = "debian-cloud"
}

data "google_compute_machine_types" "machine_types" {
  filter = "name = \"e2-micro\""
  zone   = var.zone
}

data "google_compute_zones" "zones" {
}

data "google_compute_image" "image" {
  family  = "debian-10"
  project = "debian-cloud"
}

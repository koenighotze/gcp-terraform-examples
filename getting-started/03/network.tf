resource "google_compute_network" "vpc" {
  project                 = var.project_id
  name                    = "vpc-ex-03"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnetwork" {
  project                  = var.project_id
  region                   = var.region
  name                     = "subnetwork"
  ip_cidr_range            = "10.0.0.0/16" # todo actually too large
  network                  = google_compute_network.vpc.id
  stack_type               = "IPV4_ONLY"
  private_ip_google_access = true

  log_config {
    aggregation_interval = "INTERVAL_10_MIN"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
}

resource "google_compute_firewall" "firewall" {
  project = var.project_id
  name    = "allow-ssh-http"
  network = google_compute_network.vpc.name

  #checkov:skip=CKV_GCP_2: we need ssh and http
  allow {
    protocol = "tcp"
    ports    = ["22", "80"]
  }

  #checkov:skip=CKV_GCP_106: we need ssh and http
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["webserver"]
}

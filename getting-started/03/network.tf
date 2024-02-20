resource "google_compute_network" "vpc" {
  name                    = "vpc-ex-03"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnetwork" {
  name          = "subnetwork"
  ip_cidr_range = "10.0.0.1/16" # todo actually too large
  network       = google_compute_network.vpc.id
  stack_type    = "IPV4_ONLY"
}

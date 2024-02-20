resource "google_compute_subnetwork" "subnetwork_a" {
  name          = "dschmitz-subnetwork-a"
  ip_cidr_range = "10.128.0.0/24"
  network       = google_compute_network.network.id
  private_ip_google_access = true
}

resource "google_compute_subnetwork" "subnetwork_b" {
  name          = "dschmitz-subnetwork-b"
  ip_cidr_range = "10.128.1.0/24"
  network       = google_compute_network.network.id
  private_ip_google_access = true
}

resource "google_compute_subnetwork" "subnetwork_c" {
  name          = "dschmitz-subnetwork-c"
  ip_cidr_range = "10.128.2.0/24"
  network       = google_compute_network.network.id
  private_ip_google_access = true
}

resource "google_compute_network" "network" {
  name = "dschmitz-network"
  auto_create_subnetworks = false
}
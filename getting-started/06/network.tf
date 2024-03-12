
# "google_compute_network"
# google_compute_firewall
# google_compute_subnetwork (fuer proxy und maschinen)

resource "google_compute_network" "vpc" {
  name                    = "vpc-${local.name_postfix}"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "instance_subnetwork" {
  name          = "instance-subnetwork-${local.name_postfix}"
  network       = google_compute_network.vpc.id
  ip_cidr_range = "10.1.0.0/23"
}

resource "google_compute_firewall" "firewall" {
  name          = "allow-ssh-http"
  network       = google_compute_network.vpc.id
  direction     = "INGRESS"
  priority      = 1000
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["webserver"]
  allow {
    protocol = "tcp"
    ports    = ["80", "22"]
  }
}




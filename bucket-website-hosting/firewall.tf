resource "google_compute_firewall" "ingress-firewall" {
  name    = "dschmitz-ingress-firewall"
  network = google_compute_network.network.self_link

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["dschmitz-web"]
}

resource "google_compute_firewall" "egress-firewall" {
  name    = "dschmitz-egress-firewall"
  network = google_compute_network.network.self_link

  direction = "EGRESS"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  target_tags   = ["dschmitz-web"]
}

resource "google_compute_firewall" "egress-jump-firewall" {
  name    = "dschmitz-egress-jump-firewall"
  network = google_compute_network.network.self_link

  direction = "EGRESS"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  destination_ranges = [
    "${google_compute_instance.nginx1.network_interface.0.network_ip}/32",
    "${google_compute_instance.nginx2.network_interface.0.network_ip}/32"
  ]

  target_tags   = ["dschmitz-jump"]
}

resource "google_compute_firewall" "ingress-jump-firewall" {
  name    = "dschmitz-ingress-jump-firewall"
  network = google_compute_network.network.self_link

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["dschmitz-jump"]
}
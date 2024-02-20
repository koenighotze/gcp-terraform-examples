provider "google" {
  project     = var.project_id
  region      = var.region
  zone        = var.zone
}

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

resource "google_compute_router" "router" {
  name    = "dschmitz-router"
  network = google_compute_network.network.id

  bgp {
    asn = 64514
  }
}

resource "google_compute_router_nat" "nat" {
  name                               = "dschmitz-nat"
  router                             = google_compute_router.router.name
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}

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

resource "google_compute_instance" "nginx2" {
  name         = "dschmitz-nginx2"
  machine_type = "e2-micro"
  zone         = data.google_compute_zones.zones.names[1]
  allow_stopping_for_update = true
  boot_disk {
    auto_delete = true

    initialize_params {
      image = data.google_compute_image.image.self_link
    }
  }

  network_interface {
    network = google_compute_network.network.self_link
    subnetwork = google_compute_subnetwork.subnetwork_a.self_link
  }

  metadata_startup_script = file("setup.sh")

  tags = [ "dschmitz-web" ]
}

resource "google_compute_instance" "nginx1" {
  name         = "dschmitz-nginx1"
  machine_type = "e2-micro"
  zone         = data.google_compute_zones.zones.names[0]
  allow_stopping_for_update = true
  boot_disk {
    auto_delete = true

    initialize_params {
      image = data.google_compute_image.image.self_link
    }
  }

  network_interface {
    network = google_compute_network.network.self_link
    subnetwork = google_compute_subnetwork.subnetwork_b.self_link
  }

  metadata_startup_script = file("setup.sh")

  tags = [ "dschmitz-web" ]
}

resource "google_compute_instance" "jump" {
  name         = "dschmitz-jump"
  machine_type = "e2-micro"
  zone         = data.google_compute_zones.zones.names[2]
  allow_stopping_for_update = true
  boot_disk {
    auto_delete = true

    initialize_params {
      image = data.google_compute_image.image.self_link
    }
  }

  network_interface {
    network = google_compute_network.network.self_link
    subnetwork = google_compute_subnetwork.subnetwork_c.self_link
  }

  tags = [ "dschmitz-jump" ]
}


resource "google_compute_backend_service" "default" {
  name          = "dschmitz-backend-service"
  health_checks = [google_compute_http_health_check.default.id]

  port_name = "http"
  load_balancing_scheme = "EXTERNAL"
  timeout_sec = 2

  backend {
    group = google_compute_instance_group.webservers_a.self_link
  }

  backend {
    group = google_compute_instance_group.webservers_b.self_link
  }
}

resource "google_compute_http_health_check" "default" {
  name               = "dschmitz-health-check"
  request_path       = "/"
  check_interval_sec = 1
  timeout_sec        = 1
}

resource "google_compute_instance_group" "webservers_a" {
  name        = "dschmitz-ig-a"

  instances = [
    google_compute_instance.nginx1.id
  ]

  named_port {
    name = "http"
    port = "80"
  }

  zone = google_compute_instance.nginx1.zone
}

resource "google_compute_instance_group" "webservers_b" {
  name        = "dschmitz-ig-b"

  instances = [
    google_compute_instance.nginx2.id
  ]

  named_port {
    name = "http"
    port = "80"
  }

  zone = google_compute_instance.nginx2.zone
}

resource "google_compute_global_forwarding_rule" "default" {
  name                  = "dschmitz-forwarding-rule"
  load_balancing_scheme = "EXTERNAL"

  port_range = "80"
  target = google_compute_target_http_proxy.default.id
}

resource "google_compute_target_http_proxy" "default" {
  name    = "dschmitz-proxy"
  url_map = google_compute_url_map.default.id
}

resource "google_compute_url_map" "default" {
  name            = "dschmitz-url-map"
  default_service = google_compute_backend_service.default.id
}

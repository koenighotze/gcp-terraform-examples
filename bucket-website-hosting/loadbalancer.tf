resource "google_compute_backend_service" "default" {
  name          = "${var.name_prefix}-backend-service"
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
  name               = "${var.name_prefix}-health-check"
  request_path       = "/"
  check_interval_sec = 1
  timeout_sec        = 1
}

resource "google_compute_global_forwarding_rule" "default" {
  name                  = "${var.name_prefix}-forwarding-rule"
  load_balancing_scheme = "EXTERNAL"

  port_range = "80"
  target = google_compute_target_http_proxy.default.id
}

resource "google_compute_target_http_proxy" "default" {
  name    = "${var.name_prefix}-proxy"
  url_map = google_compute_url_map.default.id
}

resource "google_compute_url_map" "default" {
  name            = "${var.name_prefix}-url-map"
  default_service = google_compute_backend_service.default.id
}

resource "google_compute_router" "router" {
  name    = "${var.name_prefix}-router"
  network = google_compute_network.network.id

  bgp {
    asn = 64514
  }
}

resource "google_compute_router_nat" "nat" {
  name                               = "${var.name_prefix}-nat"
  router                             = google_compute_router.router.name
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}

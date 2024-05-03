resource "google_compute_region_url_map" "url_map" {
  name            = "url-map-${var.name_postfix}"
  default_service = google_compute_region_backend_service.backend_service.id
}

resource "google_compute_region_target_http_proxy" "http_proxy" {
  name    = "http-lb-proxy-${var.name_postfix}"
  url_map = google_compute_region_url_map.url_map.id
}

resource "google_compute_forwarding_rule" "lb" {
  name                  = "forwarding-rule-${var.name_postfix}"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  network               = data.google_compute_network.vpc.id
  network_tier          = "STANDARD"
  port_range            = "80"
  target                = google_compute_region_target_http_proxy.http_proxy.self_link
}

resource "google_compute_forwarding_rule" "forwarding_rule" {
  name                  = "forwarding-rule-${local.name_postfix}"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  network_tier          = "STANDARD"
  port_range            = 80
  network               = google_compute_network.vpc.id
  target                = google_compute_region_target_http_proxy.http_proxy.self_link
}

resource "google_compute_region_target_http_proxy" "http_proxy" {
  name    = "http-proxy-${local.name_postfix}"
  url_map = google_compute_region_url_map.url_map.id
}

resource "google_compute_region_url_map" "url_map" {
  name = "url-map-${local.name_postfix}"

  default_service = google_compute_region_backend_service.backend_service.self_link
}

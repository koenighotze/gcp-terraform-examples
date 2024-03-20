resource "google_compute_region_url_map" "url_map" {
  name            = "url-map-${local.name_postfix}"
  default_service = google_compute_region_backend_service.backend_service.id
}

resource "google_compute_region_target_http_proxy" "http_proxy" {
  name    = "http-lb-proxy-${local.name_postfix}"
  url_map = google_compute_region_url_map.url_map.id
}

# resource "google_compute_region_health_check" "http_health_check" {
#   name = "http-health-check-${local.name_postfix}"
#   http_health_check {
#     port_name          = "http"
#     port_specification = "USE_NAMED_PORT"
#   }
#   log_config {
#     enable = true
#   }
# }

resource "google_compute_forwarding_rule" "lb" {
  name                  = "forwarding-rule-${local.name_postfix}"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  network               = google_compute_network.vpc.id
  network_tier          = "STANDARD"
  port_range            = "80"
  target                = google_compute_region_target_http_proxy.http_proxy.self_link
}

# resource "google_compute_forwarding_rule" "forwarding_rule" {
#   name                  = "forwarding-rule-${local.name_postfix}"
#   load_balancing_scheme = "EXTERNAL_MANAGED"
#   # ip_protocol           = "HTTP"
#   # port_range   = "80"
#   network_tier = "STANDARD"
#   target       = google_compute_region_target_http_proxy.default.self_link

#   # backend_service = google_compute_region_backend_service.backend_service.self_link
# }

resource "google_compute_region_target_http_proxy" "default" {
  name    = "http-proxy-${local.name_postfix}"
  url_map = google_compute_region_url_map.url_map.id
}

resource "google_compute_region_url_map" "url_map" {
  name = "url-map-${local.name_postfix}"

  default_service = google_compute_region_backend_service.backend_service.self_link
}

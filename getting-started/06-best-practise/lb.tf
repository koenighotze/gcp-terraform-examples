resource "google_compute_url_map" "url_map" {
  name            = "url-map-${local.name_postfix}"
  default_service = google_compute_backend_bucket.website_backend.id
}

resource "google_compute_target_http_proxy" "http_proxy" {
  name    = "http-lb-proxy-${local.name_postfix}"
  url_map = google_compute_url_map.url_map.id
}

resource "google_compute_global_forwarding_rule" "lb" {
  name                  = "forwarding-rule-${local.name_postfix}"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  port_range            = "80"
  target                = google_compute_target_http_proxy.http_proxy.self_link
}



# google_compute_forwarding_rule
# google_compute_region_url_map
# google_compute_target_http_proxy




# resource "google_compute_region_url_map" "url_map" {
#   name = "url-map-${local.name_postfix}"
#   default_service = google_compute_region_backend_service.backend_service.id
# }

# resource "google_compute_region_target_http_proxy" "http_proxy" {
#   name    = "http-lb-proxy-${local.name_postfix}"
#   url_map = google_compute_region_url_map.url_map.id
# }

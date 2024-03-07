resource "google_compute_forwarding_rule" "forwarding_rule" {
  name                  = "forwarding-rule-${local.name_postfix}"
  region                = var.region
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL"
  port_range            = "80"
  network_tier          = "STANDARD"

  backend_service = google_compute_region_backend_service.backend_service.self_link
}

resource "google_compute_region_backend_service" "backend_service" {
  name                  = "backend-service-${local.name_postfix}"
  protocol              = "HTTP"
  port_name             = "http"
  timeout_sec           = 10
  health_checks         = [google_compute_region_health_check.health_check.self_link]
  session_affinity      = "NONE"
  load_balancing_scheme = "EXTERNAL_MANAGED"

  backend {
    group           = google_compute_region_instance_group_manager.manager.instance_group
    balancing_mode  = "UTILIZATION"
    capacity_scaler = 1
    max_utilization = 0.9
  }
}

resource "google_compute_region_health_check" "health_check" {
  name               = "http-health-check-${local.name_postfix}"
  check_interval_sec = 5
  timeout_sec        = 5

  http_health_check {
    port_name = "http"
  }
}

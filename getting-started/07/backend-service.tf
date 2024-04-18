resource "google_compute_region_backend_service" "backend_service" {
  name                  = "backend-service-${local.name_postfix}"
  protocol              = "HTTP"
  port_name             = "http"
  health_checks         = [google_compute_region_health_check.http_health_check.id]
  load_balancing_scheme = "EXTERNAL_MANAGED"

  backend {
    group           = google_compute_region_instance_group_manager.mig.instance_group
    balancing_mode  = "UTILIZATION"
    capacity_scaler = 1
    max_utilization = 0.9
  }

  log_config {
    enable      = true
    sample_rate = 1.0
  }
}

resource "google_compute_region_health_check" "http_health_check" {
  name = "http-health-check-${local.name_postfix}"
  http_health_check {
    port_name          = "http"
    port_specification = "USE_NAMED_PORT"
  }
  log_config {
    enable = true
  }
}

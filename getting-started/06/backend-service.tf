
# google_compute_region_backend_service
# google_compute_http_health_check


resource "google_compute_region_backend_service" "backend_service" {
  name                  = "backend-service-${local.name_postfix}"
  protocol              = "HTTP"
  port_name             = "http"
  health_checks         = [google_compute_region_health_check.http_health_check.id]
  load_balancing_scheme = "EXTERNAL_MANAGED"
  network               = google_compute_network.vpc.id
  backend {
    group           = google_compute_region_instance_group_manager.mig.id
    balancing_mode  = "RATE"
    max_rate        = 100
    capacity_scaler = 1.0
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


resource "google_compute_router" "router" {
  name    = "router-${local.name_postfix}"
  network = google_compute_network.vpc.self_link
}

# needed for the mig instances to install updates
resource "google_compute_router_nat" "nat" {
  name   = "nat-${local.name_postfix}"
  router = google_compute_router.router.name

  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  subnetwork {
    name                    = google_compute_subnetwork.instance_subnetwork.name
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}

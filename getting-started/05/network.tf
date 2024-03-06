resource "google_compute_network" "vpc" {
  project                 = var.project_id
  name                    = "vpc-${local.name_postfix}"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnetwork" {
  project                  = var.project_id
  region                   = var.region
  name                     = "subnetwork-${local.name_postfix}"
  ip_cidr_range            = "10.0.0.0/16" # todo actually too large
  network                  = google_compute_network.vpc.id
  stack_type               = "IPV4_ONLY"
  private_ip_google_access = true

  log_config {
    aggregation_interval = "INTERVAL_10_MIN"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
}

resource "google_compute_firewall" "firewall" {
  project = var.project_id
  name    = "allow-ssh-http-${local.name_postfix}"
  network = google_compute_network.vpc.name

  #checkov:skip=CKV_GCP_2: we need ssh and http
  allow {
    protocol = "tcp"
    ports    = ["22", "80"]
  }

  #checkov:skip=CKV_GCP_106: we need ssh and http
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["webserver"]
}

# resource "google_compute_router" "router" {
#   project = var.project_id
#   name    = "router-${local.name_postfix}"
#   network = google_compute_network.vpc.self_link
#   region  = var.region
# }

# resource "google_compute_router_nat" "router_nat" {
#   project                = var.project_id
#   name                   = "router-nat-${local.name_postfix}"
#   router                 = google_compute_router.router.name
#   region                 = var.region
#   nat_ip_allocate_option = "AUTO_ONLY"

#   source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
# }

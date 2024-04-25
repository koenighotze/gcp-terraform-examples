
resource "google_compute_network" "vpc" {
  name                    = "vpc-${local.name_postfix}"
  auto_create_subnetworks = false
}

#checkov:skip=CKV_GCP_76: no priv google access
resource "google_compute_subnetwork" "instance_subnetwork" {
  name    = "instance-subnetwork-${local.name_postfix}"
  network = google_compute_network.vpc.id
  ip_cidr_range            = cidrsubnet(var.base_cidr_block, 15, 1)
  stack_type               = "IPV4_ONLY"
  private_ip_google_access = true

  log_config {
    aggregation_interval = "INTERVAL_10_MIN"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
}

# locals {
#   new_prefix = 23
#   num_subnets = 128
#   cidr_blocks = [ for i in range(local.num_subnets) : cidrsubnet(var.base_cidr_block, local.new_prefix, i) ]
# }

resource "google_compute_subnetwork" "proxy_subnetwork" {
  name = "proxysubnetwork-${local.name_postfix}"
  # ip_cidr_range = "10.1.0.0/23" # cidrsubnet(var.base_cidr_block, 7, 2)
  ip_cidr_range = cidrsubnet(var.base_cidr_block, 15, 2)
  network       = google_compute_network.vpc.id
  purpose       = "REGIONAL_MANAGED_PROXY"

  #checkov:skip=CKV_GCP_74: proxy network does not require this
  private_ip_google_access = false
  #checkov:skip=CKV_GCP_76: proxy network does not require this
  # private_ipv6_google_access = "DISABLE_GOOGLE_ACCESS"
  role = "ACTIVE"
}

resource "google_compute_firewall" "firewall" {
  name      = "allow-ssh-http"
  network   = google_compute_network.vpc.id
  direction = "INGRESS"
  priority  = 1000
  #checkov:skip=CKV_GCP_106:allow everybody to connect
  source_ranges = ["0.0.0.0/0"]
  target_tags   = local.firewall_target_tags
  #checkov:skip=CKV_GCP_2: we need ssh and http
  allow {
    protocol = "tcp"
    ports    = ["80", "22"]
  }
}

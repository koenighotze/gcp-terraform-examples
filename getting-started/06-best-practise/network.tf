resource "google_compute_network" "vpc" {
  name                    = "vpc-${local.name_postfix}"
  auto_create_subnetworks = false
}

# resource "google_compute_subnetwork" "proxy_subnetwork" {
#   name          = "proxysubnetwork-${local.name_postfix}"
#   ip_cidr_range = "10.2.0.0/23"
#   network       = google_compute_network.vpc.id
#   purpose       = "REGIONAL_MANAGED_PROXY"

#   #checkov:skip=CKV_GCP_74: proxy network does not require this
#   private_ip_google_access = false
#   #checkov:skip=CKV_GCP_76: proxy network does not require this
#   # private_ipv6_google_access = "DISABLE_GOOGLE_ACCESS"
#   role = "ACTIVE"
# }

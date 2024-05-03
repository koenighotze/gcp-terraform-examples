output "instance_subnetwork_name" {
  value = google_compute_subnetwork.instance_subnetwork.name
}

output "proxy_subnetwork_name" {
  value = google_compute_subnetwork.proxy_subnetwork.name
}

output "vpc_name" {
  value = google_compute_network.vpc.name
}

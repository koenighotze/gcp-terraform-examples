output "lb_url" {
  value       = "http://TODO" #${google_compute_forwarding_rule.forwarding_rule.ip_address}"
  description = "The URL of the load balancer"
}

output "bucket_name" {
  value = "gs://TODO"
}

output "instance_service_account_email" {
  value = google_service_account.instance_service_account.email
}

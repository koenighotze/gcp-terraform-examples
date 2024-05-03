output "lb_url" {
  value       = "http://${google_compute_forwarding_rule.lb.ip_address}"
  description = "The URL of the load balancer"
}

output "website_bucket_url" {
  value = module.website.website_bucket_url
}

output "instance_service_account_email" {
  value = google_service_account.instance_service_account.email
}

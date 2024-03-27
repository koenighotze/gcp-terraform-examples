output "lb_url" {
  value       = "http://${google_compute_forwarding_rule.lb.ip_address}"
  description = "The URL of the load balancer"
}

output "bucket_name" {
  value = google_storage_bucket.websitecontent.url
}

output "lb_url" {
  value       = "http://${google_compute_global_forwarding_rule.lb.ip_address}"
  description = "The URL of the load balancer"
}

output "bucket_name" {
  value = google_storage_bucket.websitecontent.url
}

output "sa_email" {
  value = var.sa_email
}

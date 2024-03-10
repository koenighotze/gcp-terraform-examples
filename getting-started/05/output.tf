output "lb_url" {
  value       = "http://${google_compute_forwarding_rule.forwarding_rule.ip_address}"
  description = "The URL of the load balancer"
}

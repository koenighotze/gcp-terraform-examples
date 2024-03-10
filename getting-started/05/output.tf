output "lb_ip" {
  value       = google_compute_forwarding_rule.forwarding_rule.IP_address
  description = "The IP address of the load balancer"
}

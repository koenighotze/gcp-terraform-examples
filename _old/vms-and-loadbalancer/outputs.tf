output "internal_web_ip_1" {
  value = google_compute_instance.nginx1.network_interface.0.network_ip
}

output "internal_web_ip_2" {
  value = google_compute_instance.nginx2.network_interface.0.network_ip
}

output "internal_jump_ip" {
  value = google_compute_instance.jump.network_interface.0.network_ip
}

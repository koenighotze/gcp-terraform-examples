resource "google_compute_instance" "nginx2" {
  name         = "${var.name_prefix}-nginx2"
  machine_type = "e2-micro"
  zone         = data.google_compute_zones.zones.names[1]
  allow_stopping_for_update = true
  boot_disk {
    auto_delete = true

    initialize_params {
      image = data.google_compute_image.image.self_link
    }
  }

  network_interface {
    network = google_compute_network.network.self_link
    subnetwork = google_compute_subnetwork.subnetwork_a.self_link
  }

  metadata_startup_script = file("setup.sh")

  tags = [ "${var.name_prefix}-web" ]

  labels = merge(local.common_labels, { name = "${var.name_prefix}-${var.environment}-nginx2" })
}

resource "google_compute_instance" "nginx1" {
  name         = "${var.name_prefix}-nginx1"
  machine_type = "e2-micro"
  zone         = data.google_compute_zones.zones.names[0]
  allow_stopping_for_update = true
  boot_disk {
    auto_delete = true

    initialize_params {
      image = data.google_compute_image.image.self_link
    }
  }

  network_interface {
    network = google_compute_network.network.self_link
    subnetwork = google_compute_subnetwork.subnetwork_b.self_link
  }

  metadata_startup_script = file("setup.sh")

  tags = [ "${var.name_prefix}-web" ]

  labels = merge(local.common_labels, { name = "${var.name_prefix}-${var.environment}-nginx1" })
}

resource "google_compute_instance" "jump" {
  name         = "${var.name_prefix}-jump"
  machine_type = "e2-micro"
  zone         = data.google_compute_zones.zones.names[2]
  allow_stopping_for_update = true
  boot_disk {
    auto_delete = true

    initialize_params {
      image = data.google_compute_image.image.self_link
    }
  }

  network_interface {
    network = google_compute_network.network.self_link
    subnetwork = google_compute_subnetwork.subnetwork_c.self_link
  }

  tags = [ "${var.name_prefix}-jump" ]

  labels = merge(local.common_labels, { name = "${var.environment}-rtb" })
}

resource "google_compute_instance_group" "webservers_a" {
  name        = "${var.name_prefix}-ig-a"

  instances = [
    google_compute_instance.nginx1.id
  ]

  named_port {
    name = "http"
    port = "80"
  }

  zone = google_compute_instance.nginx1.zone
}

resource "google_compute_instance_group" "webservers_b" {
  name        = "${var.name_prefix}-ig-b"

  instances = [
    google_compute_instance.nginx2.id
  ]

  named_port {
    name = "http"
    port = "80"
  }

  zone = google_compute_instance.nginx2.zone
}

output "internal_web_ip_1" {
  value = google_compute_instance.nginx1.network_interface.0.network_ip
}

output "internal_web_ip_2" {
  value = google_compute_instance.nginx2.network_interface.0.network_ip
}

output "internal_jump_ip" {
  value = google_compute_instance.jump.network_interface.0.network_ip
}

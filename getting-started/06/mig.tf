# google_compute_region_instance_group_manager

# google_compute_region_instance_template

resource "google_compute_region_instance_template" "template" {
  name         = "template-${local.name_postfix}"
  description  = "Template for the webservers"
  machine_type = data.google_compute_machine_types.machine_types.machine_types[0].name

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = google_service_account.sa.email
    scopes = ["cloud-platform"]
  }

  disk {
    source_image = data.google_compute_image.image.self_link
    auto_delete  = true
    boot         = true
  }

  network_interface {
    network    = google_compute_network.vpc.id
    subnetwork = google_compute_subnetwork.instance_subnetwork.id
    access_config {
      network_tier = "STANDARD"
    }
  }

  scheduling {
    provisioning_model = "SPOT"
    preemptible        = true
    automatic_restart  = false
  }
  metadata_startup_script = "echo hi > /test.txt"

  tags = ["webserver"]
}

resource "google_compute_instance" "webserver" {
  project                   = var.project_id
  name                      = "webserver-${local.name_postfix}"
  zone                      = var.zone
  machine_type              = data.google_compute_machine_types.machine_types.machine_types[0].name
  allow_stopping_for_update = true
  enable_display            = false

  #checkov:skip=CKV_GCP_38: Use google keys
  boot_disk {
    auto_delete = true

    initialize_params {
      image = data.google_compute_image.image.self_link
    }
  }

  shielded_instance_config {
    enable_integrity_monitoring = true
    enable_vtpm                 = true
  }

  network_interface {
    network    = google_compute_network.vpc.self_link
    subnetwork = google_compute_subnetwork.subnetwork.self_link

    stack_type = "IPV4_ONLY"

    # needed for external IP
    #checkov:skip=CKV_GCP_40: We will use external IP
    access_config {
    }
  }

  service_account {
    email = google_service_account.instance_service_account.email
    # https://cloud.google.com/sdk/gcloud/reference/alpha/compute/instances/set-scopes#--scopes
    scopes = ["cloud-platform"]
  }

  metadata = {
    #checkov:skip=CKV_GCP_32: We will use ssh keys down the line
    block-project-ssh-keys = false
  }

  metadata_startup_script = <<SCRIPT
#!/bin/bash
sudo apt-get update
sudo apt-get install -y nginx
sudo systemctl start nginx
sudo systemctl enable nginx
SCRIPT

  tags = ["webserver"]
}

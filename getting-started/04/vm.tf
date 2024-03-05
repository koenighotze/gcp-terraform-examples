resource "google_compute_instance" "webserver" {
  project                   = var.project_id
  name                      = "webserver-${local.name_postfix}"
  zone                      = var.zone
  machine_type              = "e2-micro"
  allow_stopping_for_update = true
  enable_display            = false

  #checkov:skip=CKV_GCP_38: Use google keys
  boot_disk {
    auto_delete = true

    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }

  shielded_instance_config {
    enable_integrity_monitoring = true
    enable_vtpm                 = true
  }

  network_interface {
    network    = google_compute_network.vpc.id
    subnetwork = google_compute_subnetwork.subnetwork.id

    stack_type = "IPV4_ONLY"

    # this VM does not have a public IP and should be accessed via 
    # the routing rules
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

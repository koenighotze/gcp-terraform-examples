resource "google_compute_instance" "webserver" {
  project                   = var.project_id
  name                      = "webserver"
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

    # needed for external IP
    access_config {
    }
  }

  metadata_startup_script = "echo hi > /test.txt"

  service_account {
    email = google_service_account.instance_service_account.email
    # https://cloud.google.com/sdk/gcloud/reference/alpha/compute/instances/set-scopes#--scopes
    scopes = ["cloud-platform"]
  }

  metadata = {
    #checkov:skip=CKV_GCP_32: We will use ssh keys down the line
    block-project-ssh-keys = false
  }

  tags = ["http-server"]
}

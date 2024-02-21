resource "google_compute_instance" "webserver" {
  project                   = var.project_id
  name                      = "webserver"
  zone                      = var.zone
  machine_type              = "e2-micro"
  allow_stopping_for_update = true
  enable_display            = false

  boot_disk {
    auto_delete = true

    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }

  network_interface {
    network    = google_compute_network.vpc.id
    subnetwork = google_compute_subnetwork.subnetwork.id

    stack_type = "IPV4_ONLY"
  }

  metadata_startup_script = "echo hi > /test.txt"

  service_account {
    email = google_service_account.instance_service_account.email
    # https://cloud.google.com/sdk/gcloud/reference/alpha/compute/instances/set-scopes#--scopes
    scopes = ["cloud-platform"]
  }
}

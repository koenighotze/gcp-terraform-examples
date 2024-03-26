resource "google_compute_region_instance_group_manager" "mig" {
  name                      = "mig-${local.name_postfix}-${random_integer.mig.id}"
  base_instance_name        = local.name_postfix
  distribution_policy_zones = slice(data.google_compute_zones.available.names, 0, 2)
  target_size               = 2

  named_port {
    name = "http"
    port = 80
  }

  version {
    instance_template = google_compute_region_instance_template.template.self_link
    name              = "instance"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_region_instance_template" "template" {
  name         = "webserver-template-${local.name_postfix}--${random_integer.mig.id}"
  machine_type = data.google_compute_machine_types.machine_types.machine_types[0].name

  service_account {
    email = google_service_account.instance_service_account.email
    # https://cloud.google.com/sdk/gcloud/reference/alpha/compute/instances/set-scopes#--scopes
    scopes = ["cloud-platform"]
  }

  disk {
    source_image = data.google_compute_image.image.self_link
    auto_delete  = true
    boot         = true
  }

  network_interface {
    network    = google_compute_network.vpc.self_link
    subnetwork = google_compute_subnetwork.instance_subnetwork.self_link

    stack_type = "IPV4_ONLY"

    # no public IP
    # access_config {
    #   network_tier = "STANDARD"
    # }
  }

  scheduling {
    preemptible       = "true"
    automatic_restart = "false"
  }

  #checkov:skip=CKV_GCP_38: Use google keys
  shielded_instance_config {
    enable_integrity_monitoring = true
    enable_vtpm                 = true
  }

  metadata = {
    #checkov:skip=CKV_GCP_32: We will use ssh keys down the line
    block-project-ssh-keys = false
  }

  metadata_startup_script = templatefile("./scripts/setup-webserver.sh", { bucket_url = google_storage_bucket.websitecontent.url })

  tags           = ["webserver"]
  can_ip_forward = false

  lifecycle {
    create_before_destroy = true
  }
}

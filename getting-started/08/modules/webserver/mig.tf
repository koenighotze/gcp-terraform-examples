locals {
  number_of_available_zones = length(data.google_compute_zones.available.names)
  distribution_policy_zones = slice(data.google_compute_zones.available.names, 0, min(local.number_of_available_zones, var.mig_pool_size))
}

resource "google_compute_region_instance_group_manager" "mig" {
  name                      = "webserver-mig-${var.name_postfix}-${random_integer.mig.id}"
  base_instance_name        = var.name_postfix
  distribution_policy_zones = local.distribution_policy_zones
  target_size               = var.mig_pool_size

  named_port {
    name = "http"
    port = 80
  }

  version {
    instance_template = google_compute_region_instance_template.template.self_link
    name              = "instance"
  }
}

resource "google_compute_region_instance_template" "template" {
  name         = "webserver-template-${var.name_postfix}--${random_integer.mig.id}"
  machine_type = data.google_compute_machine_types.machine_types.machine_types[0].name

  service_account {
    email = var.instance_service_account_email
    # https://cloud.google.com/sdk/gcloud/reference/alpha/compute/instances/set-scopes#--scopes
    scopes = ["cloud-platform"]
  }

  disk {
    source_image = data.google_compute_image.image.self_link
    auto_delete  = true
    boot         = true
  }

  network_interface {
    network    = data.google_compute_network.vpc.self_link
    subnetwork = data.google_compute_subnetwork.subnetwork.self_link

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
    block-project-ssh-keys = true
  }

  metadata_startup_script = templatefile("${path.module}/scripts/setup-webserver.sh", { bucket_url = var.website_bucket_url })

  tags           = var.firewall_target_tags
  can_ip_forward = false
}

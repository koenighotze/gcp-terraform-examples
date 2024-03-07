
resource "google_compute_region_instance_group_manager" "manager" {
  name               = "mig-${local.name_postfix}"
  base_instance_name = local.name_postfix
  region             = var.region

  distribution_policy_zones = ["europe-west3-a", "europe-west3-b"] # TODO Dynamic

  target_size = 2 # variable

  named_port {
    name = "http"
    port = 80
  }

  version {
    name              = "instance"
    instance_template = google_compute_region_instance_template.template.self_link
  }
}

resource "google_compute_region_instance_template" "template" {
  project = var.project_id
  name    = "webserver-template-${local.name_postfix}"

  tags = ["webserver"]

  machine_type = data.google_compute_machine_types.machine_types.machine_types[0].name

  can_ip_forward = false

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }

  #checkov:skip=CKV_GCP_38: Use google keys
  disk {
    source_image = data.google_compute_image.image.self_link
    auto_delete  = true
    boot         = true
  }

  shielded_instance_config {
    enable_integrity_monitoring = true
    enable_vtpm                 = true
  }

  network_interface {
    network    = google_compute_network.vpc.self_link
    subnetwork = google_compute_subnetwork.subnetwork.self_link

    stack_type = "IPV4_ONLY"

    # no external IP, we will use a load balancer
    # access_config {
    # }
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
}

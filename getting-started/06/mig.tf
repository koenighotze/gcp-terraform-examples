resource "google_compute_region_instance_group_manager" "mig" {
  name = "mig-${local.name_postfix}"

  base_instance_name        = "webserver-${random_integer.integer.result}"
  distribution_policy_zones = slice(data.google_compute_zones.available.names, 0, 2)
  target_size               = 2

  named_port {
    name = "http"
    port = 80
  }

  version {
    instance_template = google_compute_region_instance_template.template.id
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_region_instance_template" "template" {
  name         = "template-${local.name_postfix}-${random_integer.integer.result}"
  description  = "Template for the webservers"
  machine_type = data.google_compute_machine_types.machine_types.machine_types[0].name

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = google_service_account.instance_service_account.email
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

  metadata_startup_script = <<SCRIPT
#!/bin/bash
sudo apt-get update
sudo apt-get install -y nginx
sudo sed -e "s,nginx,$HOSTNAME," < /usr/share/nginx/html/index.html > /tmp/index.html
sudo mv /tmp/index.html /var/www/html/index.html
sudo systemctl start nginx
sudo systemctl enable nginx
SCRIPT

  tags = ["webserver"]

  lifecycle {
    create_before_destroy = true
  }
}

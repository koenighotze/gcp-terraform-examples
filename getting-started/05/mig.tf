
resource "google_compute_region_instance_group_manager" "manager" {
  name               = "mig-${local.name_postfix}"
  base_instance_name = local.name_postfix
  region             = var.region

  distribution_policy_zones = ["us-central1-a", "us-central1-f"] # TODO Dynamic

  target_size = 2 # variable

  named_port {
    name = "http"
    port = 80
  }

  version {
    name              = "instance"
    instance_template = google_compute_instance_template.template.self_link_unique
  }

}

resource "google_compute_instance_template" "template" {

}



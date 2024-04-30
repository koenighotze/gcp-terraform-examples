resource "google_service_account" "instance_service_account" {
  account_id   = "sa-${local.name_postfix}"
  display_name = "SA for webservice instances"
}

resource "google_project_iam_member" "iam_member" {
  project  = var.project_id
  for_each = toset(["roles/logging.logWriter"])
  role     = each.value

  member = "serviceAccount:${google_service_account.instance_service_account.email}"
}

resource "google_service_account_iam_member" "iam_binding_service_account" {
  service_account_id = google_service_account.instance_service_account.name
  role               = "roles/iam.serviceAccountUser"

  member = "serviceAccount:${var.sa_email}"
}

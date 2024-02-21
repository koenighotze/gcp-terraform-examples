resource "google_service_account" "instance_service_account" {
  project      = var.project_id
  account_id   = "instance-service-account"
  display_name = "Instance Service Account"
}

resource "google_project_iam_member" "iam_binding_project" {
  project = var.project_id
  for_each = toset([
    "roles/logging.logWriter",
  ])

  role = each.key

  member = "serviceAccount:${google_service_account.instance_service_account.email}"
}

resource "google_service_account_iam_member" "iam_binding_service_account" {
  service_account_id = google_service_account.instance_service_account.name
  role               = "roles/iam.serviceAccountUser"

  member = "serviceAccount:${var.sa_email}"
}

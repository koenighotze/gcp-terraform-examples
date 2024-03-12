resource "google_service_account" "sa" {
  account_id   = "sa-${local.name_postfix}"
  display_name = "SA for webservice instances"
}

resource "google_service_account_iam_member" "iam_member" {
  for_each           = toset(["roles/storage.objectViewer", "roles/storage.admin", "roles/logging.logWriter"])
  service_account_id = google_service_account.sa.id
  role               = each.value
  member             = "serviceAccount:${google_service_account.sa.email}"
}



resource "google_service_account" "sa" {
  account_id   = "sa-${local.name_postfix}"
  display_name = "SA for webservice instances"
}

resource "google_project_iam_member" "iam_member" {
  project  = var.project_id
  for_each = toset(["roles/logging.logWriter"])
  role     = each.value
  member   = "serviceAccount:${google_service_account.sa.email}"
}

resource "google_storage_bucket" "websitecontent" {
  #checkov:skip=CKV_GCP_62: No logging needed
  name     = "website-${local.name_postfix}"
  location = var.region
  # we do not use object level ACLs
  uniform_bucket_level_access = true
  force_destroy               = true
  storage_class               = "REGIONAL"
  public_access_prevention    = "enforced"
  versioning {
    enabled = true
  }
}

resource "google_storage_bucket_iam_member" "member" {
  count  = var.debug
  bucket = google_storage_bucket.websitecontent.name
  role   = "roles/storage.admin"
  member = "user:${var.local_user_email}"
}

data "google_iam_policy" "bucket_iam_policy" {
  binding {
    role = "roles/storage.objectUser"
    members = [
      "serviceAccount:${google_service_account.instance_service_account.email}",
    ]
  }
}

resource "google_storage_bucket_iam_policy" "bucket_iam_policy" {
  bucket      = google_storage_bucket.websitecontent.name
  policy_data = data.google_iam_policy.bucket_iam_policy.policy_data
}

resource "google_storage_bucket_object" "bucket_object" {
  for_each = toset([
    "index.html",
    "404.html"
  ])

  name   = each.value
  bucket = google_storage_bucket.websitecontent.name
  source = "./website/${each.value}"

  content_type = "text/html"
}

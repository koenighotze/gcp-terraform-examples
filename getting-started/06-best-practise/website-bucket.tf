resource "google_storage_bucket" "websitecontent" {
  #checkov:skip=CKV_GCP_62: No logging needed
  name     = "website-${local.name_postfix}"
  location = var.region
  # we use object level ACLs
  uniform_bucket_level_access = true
  force_destroy               = true
  storage_class               = "REGIONAL"
  #checkov:skip=CKV_GCP_114: Website is public
  public_access_prevention = "inherited"

  versioning {
    enabled = true
  }

  website {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }
}

resource "google_storage_bucket_iam_binding" "public_rule" {
  bucket = google_storage_bucket.websitecontent.id
  role   = "roles/storage.objectViewer"

  #checkov:skip=CKV_GCP_28: This is a website!
  members = [
    "allUsers"
  ]
}

resource "google_storage_bucket_object" "bucket_object_index" {
  for_each = toset(["index.html", "404.html"])

  name   = each.value
  bucket = google_storage_bucket.websitecontent.name
  source = "./website/${each.value}"

  content_type = "text/html"
}

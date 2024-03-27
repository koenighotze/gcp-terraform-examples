resource "google_storage_bucket" "websitecontent" {
  #checkov:skip=CKV_GCP_62: No logging needed
  name     = "website-${local.name_postfix}"
  location = var.region
  # we use object level ACLs
  uniform_bucket_level_access = true
  force_destroy               = true
  storage_class               = "REGIONAL"
  public_access_prevention    = "enforced"

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
    # "allUsers",
    "allAuthenticatedUsers"
  ]
}

resource "google_storage_bucket_object" "bucket_object_index" {
  name   = "index.html"
  bucket = google_storage_bucket.websitecontent.name
  source = "./website/index.html"

  # content_encoding = ""
  # content_language = ""
  content_type = "text/html"
}

resource "google_storage_bucket_object" "bucket_object_error" {
  name   = "404.html"
  bucket = google_storage_bucket.websitecontent.name
  source = "./website/404.html"

  # content_encoding = ""
  # content_language = ""
  content_type = "text/html"
}

# variable "bucket_objects" {
#   description = "Map of bucket objects"
#   type        = map(string)
#   default = {
#     "index.html" = "./website/index.html"
#     "404.html"   = "./website/404.html"
#   }
# }

# resource "google_storage_bucket_object" "bucket_object" {
#   for_each = var.bucket_objects

#   name   = each.key
#   bucket = google_storage_bucket.websitecontent.name
#   source = each.value

#   # content_encoding = ""
#   # content_language = ""
#   content_type = "text/html"
# }



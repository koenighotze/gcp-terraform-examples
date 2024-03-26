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

data "google_iam_policy" "bucket_iam_policy" {
  binding {
    role = "roles/storage.admin"
    members = [
      "user:${var.local_user}",
    ]
  }

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

# does this work?
# resource "google_storage_bucket_object" "bucket_object_index" {
#   name   = "/"
#   bucket = google_storage_bucket.bucket.name
#   source = "website/"

#   # content_encoding = ""
#   # content_language = ""
#   content_type = "text/html"
# }


# Replace with for_each and map?

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

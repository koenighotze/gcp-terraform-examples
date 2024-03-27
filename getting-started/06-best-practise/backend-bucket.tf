resource "google_compute_backend_bucket" "website_backend" {
  name        = "website-backend-${local.name_postfix}"
  bucket_name = google_storage_bucket.websitecontent.name
  enable_cdn  = false
}
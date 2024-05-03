variable "website_bucket_name" {
  description = "The name of the bucket to store the website content"
  type        = string
  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9-.]{1,61}[a-z0-9]$", var.website_bucket_name))
    error_message = "The website_bucket_name must start and end with a lowercase letter or number, and only contain lowercase letters, numbers, and dashes. It must be between 3 and 63 characters."
  }
}

variable "region" {
  description = "The region to deploy resources into"
  type        = string
}

variable "instance_service_account_email" {
  description = "The email of the service account to give access to the bucket"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9-]+@[a-zA-Z0-9-]+\\.iam\\.gserviceaccount\\.com$", var.instance_service_account_email))
    error_message = "The instance_service_account_email must be in the format of 'service-account-name@project-id.iam.gserviceaccount.com'."
  }
}

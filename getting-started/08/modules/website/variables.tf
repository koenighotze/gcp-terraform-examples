variable "name_postfix" {
  description = "A postfix to append to the name of the resources"
  type        = string
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

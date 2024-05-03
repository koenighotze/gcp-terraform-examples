variable "name_postfix" {
  description = "A postfix to append to the name of the resources"
  type        = string
}

variable "vpc_name" {
  description = "The name of the VPC to deploy resources into"
  type        = string
}

variable "subnet_name" {
  description = "The name of the subnet to deploy resources into"
  type        = string
}

variable "zone" {
  description = "The zone to deploy resources into"
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

variable "firewall_target_tags" {
  description = "The target tags to apply to the firewall rule"
  type        = list(string)
}

variable "website_bucket_url" {
  description = "The URL of the website bucket"
  type        = string
}

variable "mig_pool_size" {
  description = "The number of instances in the MIG"
  type        = number
  default     = 2
}

variable "machine_type_name" {
  description = "The machine type name to use for the instances"
  type        = string
  default     = "e2-micro"
}


variable "image_family" {
  description = "The image family to use for the instances"
  type        = string
  default     = "debian-12"
}

variable "image_project" {
  description = "The project of the image to use for the instances"
  type        = string
  default     = "debian-cloud"
}

variable "project_id" {
  description = "The project ID to deploy resources into"
  type        = string

  validation {
    condition     = length(var.project_id) > 0 && can(regex("[a-z0-9-]{6,30}", var.project_id))
    error_message = "Project ID must only contain lowercase letters, numbers, and hyphens, and be between 6-30 characters long"
  }
}

variable "region" {
  description = "The region to deploy resources into"
  type        = string
  default     = "europe-west3"
}

variable "zone" {
  description = "The zone to deploy resources into"
  type        = string
  default     = "europe-west3-a"
}

variable "sa_email" {
  type = string

  validation {
    condition     = length(var.sa_email) > 0 && can(regex("[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}", var.sa_email))
    error_message = "Invalid service account email format. Please provide a valid email address."
  }
}

variable "rebuild_mig" {
  type    = bool
  default = false
}

variable "mig_pool_size" {
  type    = number
  default = 2

  validation {
    condition     = var.mig_pool_size >= 1
    error_message = "Invalid mig_pool_size."
  }
}

variable "base_cidr_block" {
  type    = string
  default = "10.0.0.0/8"

  validation {
    condition     = can(cidrsubnet(var.base_cidr_block, 0, 0))
    error_message = "The value given for CIDR block is not a valid CIDR notation."
  }
}

variable "ingress_ip_ranges" {
  description = "IP ranges allowed to access the website"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "extra_labels" {
  description = "Extra labels to add to resources"
  type        = map(string)
  default     = {}
}

variable "git_sha" {
  description = "The git sha of the current commit"
  type        = string
  default     = "unknown"
}

variable "project_id" {
  description = "The project ID to deploy resources into"
  type        = string

  validation {
    condition = length(var.project_id) > 0 && can(regex("[a-z0-9-]{6,30}", var.project_id))
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
    condition = length(var.sa_email) > 0 && can(regex("[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}", var.sa_email))
    error_message = "Invalid service account email format. Please provide a valid email address."
  }
}

variable "debug" {
  type = number
  default = 0
  description = "Set to 1 to enable debug resources"

  validation {
    condition = var.debug == 0 || var.debug == 1
    error_message = "Debug must be zero or one."
  }
}

variable "rebuild_mig" {
  type    = bool
  default = false
}

variable "local_user_email" {
  type = string
  default = "only@for.debugging"

  validation {
    condition = length(var.local_user_email) > 0 && can(regex("[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}", var.local_user_email))
    error_message = "Invalid service account email format. Please provide a valid email address."
  }
}

# variable "number_of_backend_services_size" {
#   type    = number
#   default = 2

#   validation {
#     condition = var.number_of_backend_services_size >= 1
#     error_message = "Invalid number_of_backend_services_size."
#   }
# }

variable "mig_pool_size" {
  type    = number
  default = 2

  validation {
    condition = var.mig_pool_size >= 1
    error_message = "Invalid mig_pool_size."
  }
}

# variable "base_cidr_block" {
#   type = string
#   default = "10.1.0.0/16"

#   validation {
#     condition     = can(cidrsubnet(var.base_cidr_block, 0, 0))
#     error_message = "The value given for CIDR block is not a valid CIDR notation."
#   }
# }
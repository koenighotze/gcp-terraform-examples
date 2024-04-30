variable "project_id" {
  description = "The project ID to deploy resources into"
  type        = string
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
}

variable "target_size" {
  type    = number
  default = 2
}


variable "git_sha" {
  description = "The git sha of the current commit"
  type        = string
  default     = "unknown"
}

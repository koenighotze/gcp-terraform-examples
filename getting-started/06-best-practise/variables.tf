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

# variable "target_size" {
#   type    = number
#   default = 2
# }

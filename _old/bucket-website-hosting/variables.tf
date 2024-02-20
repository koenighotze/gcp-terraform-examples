variable "name_prefix" {
  type    = string
  default = "dschmitz"
}

variable "billing_code_tag" {
  type    = string
  default = "gcp-training"
}

variable "environment" {
  type    = string
  default = "development"
}

variable "region" {
  type    = string
  default = "europe-west3"
}

variable "zone" {
  type    = string
  default = "europe-west3-c"
}

variable "project_id" {
  type = string
}

variable "name_prefix" {
  type = string
  default = "dschmitz"
}

variable "billing_code_tag" {
  type = string
  default = "abc123"
}

variable "environment" {
  type = string
  default = "development"
}

variable "region" {
  type = string
  default = "europe-west1"
}

variable "zone" {
  type = string
  default = "europe-west1-c"
}

variable "project_id" {
  type = string
}

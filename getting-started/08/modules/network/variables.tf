variable "name_postfix" {
  description = "A postfix to append to the name of the resources"
  type        = string
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

variable "firewall_target_tags" {
  description = "The target tags to apply to the firewall rule"
  type        = list(string)
}

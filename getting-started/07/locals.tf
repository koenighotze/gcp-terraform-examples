locals {
  name_postfix = "ex-07-${random_integer.integer.result}"

  firewall_target_tags = ["webserver"]
}

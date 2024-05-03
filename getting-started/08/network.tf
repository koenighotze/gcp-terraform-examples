module "network" {
  source = "./modules/network"

  name_postfix         = local.name_postfix
  base_cidr_block      = var.base_cidr_block
  ingress_ip_ranges    = var.ingress_ip_ranges
  firewall_target_tags = local.firewall_target_tags
}

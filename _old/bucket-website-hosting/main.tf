locals {
  common_labels = {
    billingcode = var.billing_code_tag,
    environment = var.environment
  }

  bucket_name = "${var.name_prefix}-${var.environment}-${random_integer.rand.result}"
}
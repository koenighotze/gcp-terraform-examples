resource "random_integer" "integer" {
  max = 999999
  min = 111111
}

resource "random_integer" "mig" {
  max = 999999
  min = 1

  keepers = {
    mig = var.rebuild_mig
  }
}

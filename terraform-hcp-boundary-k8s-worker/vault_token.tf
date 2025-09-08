provider "vault" {
  address   = var.vault_address
  namespace = var.vault_namespace
  token     = var.vault_token
}
resource "vault_token" "boundary" {
  no_parent    = true
  policies     = ["dev-team", "superadmin", "admin-policy"]
  display_name = "boundary cred store"
  renewable    = true
  period       = "72h"

}

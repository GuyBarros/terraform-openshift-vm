resource "vault_token" "boundary" {
  no_parent    = true
  policies     = ["dev-team", "superadmin", "admin-policy"]
  display_name = "boundary cred store"
  renewable    = true
  period       = "72h"

}

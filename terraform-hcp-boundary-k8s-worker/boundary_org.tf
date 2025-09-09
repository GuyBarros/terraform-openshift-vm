resource "boundary_scope" "app" {
  name                     = var.organization_name
  description              = "scope for ${var.organization_name}"
  scope_id                 = "global"
  auto_create_admin_role   = true
  auto_create_default_role = true
}
# resource "boundary_scope_policy_attachment" "org_admin" {
#   policy_id = var.admin_policy_id
#   scope_id  = boundary_scope.app.id

# }
resource "boundary_scope" "app_infra" {
  name                     = "${var.organization_name}_infrastrcture"
  description              = "${var.organization_name} project!"
  scope_id                 = boundary_scope.app.id
  auto_create_admin_role   = true
  auto_create_default_role = true
}
# resource "boundary_scope_policy_attachment" "proj_admin" {
#   policy_id = var.admin_policy_id
#   scope_id  = boundary_scope.app_infra.id

# }

resource "boundary_credential_store_vault" "app_vault" {
  name            = "appHCP_Vault"
  description     = "app Vault Credential Store"
  address         = var.vault_address
  token           = vault_token.boundary.client_token
  namespace       = var.vault_namespace
  scope_id        = boundary_scope.app_infra.id
  tls_skip_verify = true
}


resource "boundary_credential_library_vault_ssh_certificate" "vault_ssh_cert" {
  name                = "ssh-certs"
  description         = "Vault SSH Cert Library"
  credential_store_id = boundary_credential_store_vault.app_vault.id
  path                = "ssh-client-signer/sign/boundary-client" # change to correct Vault endpoint and role
  username            = "cloud-user"                             # change to valid username
}

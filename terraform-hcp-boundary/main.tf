provider "boundary" {
  addr                   = var.boundary_address
  auth_method_id         = var.boundary_auth_method_id
  auth_method_login_name = var.boundary_username
  auth_method_password   = var.boundary_password
}


resource "boundary_scope" "app" {
  name                     = var.organization_name
  description              = "scope for ${var.organization_name}"
  scope_id                 = "global"
  auto_create_admin_role   = true
  auto_create_default_role = true
}
resource "boundary_scope" "app_infra" {
  name                     = "${var.organization_name}_infrastrcture"
  description              = "${var.organization_name} project!"
  scope_id                 = boundary_scope.app.id
  auto_create_admin_role   = true
  auto_create_default_role = true
}

resource "boundary_host_catalog_static" "backend_servers" {
  name        = "backend_servers"
  description = "Backend servers host catalog"
  scope_id    = boundary_scope.app_infra.id
}

resource "boundary_host_static" "backend_servers" {
  type            = "static"
  name            = "VM on Openshift"
  description     = "IP Address for the VM"
  address         = var.vm_address
  host_catalog_id = boundary_host_catalog_static.backend_servers.id
}

resource "boundary_host_set_static" "backend_servers_ssh" {
  type            = "static"
  name            = "backend_servers_ssh"
  description     = "Host set for backend servers"
  host_catalog_id = boundary_host_catalog_static.backend_servers.id
  host_ids        = [boundary_host_static.backend_servers.id]
}


resource "boundary_target" "backend_servers_ssh" {
  type                     = "ssh"
  name                     = var.target_name
  description              = "Openshift SSH target"
  scope_id                 = boundary_scope.app_infra.id
  default_port             = "22"
  default_client_port      = "22"
  session_connection_limit = -1
  egress_worker_filter     = " \"${var.organization_name}\" in \"/tags/type\" "
  host_source_ids = [
    boundary_host_set_static.backend_servers_ssh.id
  ]
  injected_application_credential_source_ids = [
    boundary_credential_library_vault_ssh_certificate.vault_ssh_cert.id
  ]
  # enable_session_recording = true
  #  storage_bucket_id        = boundary_storage_bucket.doormat_example.id
}

resource "boundary_alias_target" "ssh_alias" {
  name           = "OpenshiftVM SSH Target Alias"
  description    = "Alais for Openshift VM SSH targets"
  scope_id       = "global"
  value          = var.vm_address_alias
  destination_id = boundary_target.backend_servers_ssh.id
  # authorize_session_host_id = boundary_host_static.bar.id
}

resource "boundary_credential_store_vault" "app_vault" {
  name            = "appHCP_Vault"
  description     = "app Vault Credential Store"
  address         = var.vault_address
  token           = vault_token.boundary.client_token
  namespace       = var.vault_namespace
  scope_id        = boundary_scope.app_infra.id
  tls_skip_verify = true
}

resource "boundary_credential_library_vault" "ssh" {
  name                = "vault_token"
  description         = "Credential Library for Vault Token"
  credential_store_id = boundary_credential_store_vault.app_vault.id
  path                = "boundary_creds/data/ssh" # change to Vault backend path
  http_method         = "GET"
}



resource "boundary_credential_library_vault" "test_token" {
  name                = "test_token"
  description         = "temporary linux user"
  credential_type     = "username_password"
  credential_store_id = boundary_credential_store_vault.app_vault.id
  path                = "boundary_creds/data/linux-user" # change to Vault backend path
  http_method         = "GET"
}

resource "boundary_credential_library_vault_ssh_certificate" "vault_ssh_cert" {
  name                = "ssh-certs"
  description         = "Vault SSH Cert Library"
  credential_store_id = boundary_credential_store_vault.app_vault.id
  path                = "ssh-client-signer/sign/boundary-client" # change to correct Vault endpoint and role
  username            = "cloud-user"                                 # change to valid username
}

provider "boundary" {
  addr                   = var.boundary_address
  auth_method_id         = var.boundary_auth_method_id
  auth_method_login_name = var.boundary_username
  auth_method_password   = var.boundary_password
}

data "boundary_scope" "app" {
  name                     = var.organization_name
  scope_id                 = "global"

}
data "boundary_scope" "app_infra" {
  name                     = "${var.organization_name}_infrastrcture"
  scope_id                 = data.boundary_scope.app.id

}



resource "boundary_target" "vm_ssh" {
  type                     = "ssh"
  name                     = var.target_name
  description              = "Openshift SSH target"
  scope_id                 = data.boundary_scope.app_infra.id
  default_port             = "22"
  default_client_port      = "22"
  session_connection_limit = -1
  egress_worker_filter     = " \"${var.organization_name}\" in \"/tags/type\" "
  address = var.vm_address
  injected_application_credential_source_ids = [
    var.boundary_cred_ssh_scope_id
  ]
  # enable_session_recording = true
  #  storage_bucket_id        = boundary_storage_bucket.doormat_example.id
}

resource "boundary_alias_target" "ssh_alias" {
  name           = "OpenshiftVM SSH Target Alias"
  description    = "Alais for Openshift VM SSH targets"
  scope_id       = "global"
  value          = var.vm_address_alias
  destination_id = boundary_target.vm_ssh.id
  # authorize_session_host_id = boundary_host_static.bar.id
}


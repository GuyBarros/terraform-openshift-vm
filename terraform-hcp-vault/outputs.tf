

output "boundary-token" {
  value     = vault_token.boundary.client_token
  sensitive = true
}

output "ssh_CA_public_key" {
  value = vault_ssh_secret_backend_ca.ssh_backend.public_key
}

output "ssh_CA_public_key_url" {
  value = "${var.vault_address}/v1/${var.vault_namespace}/${vault_mount.ssh_mount.path}/public_key"

}

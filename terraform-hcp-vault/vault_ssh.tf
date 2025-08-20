resource "vault_mount" "ssh_mount" {

  path        = "ssh-client-signer"
  type        = "ssh"
  description = "SSH Mount"
}

resource "vault_ssh_secret_backend_ca" "ssh_backend" {

  backend              = vault_mount.ssh_mount.path
  generate_signing_key = true
  # public_key  = file(var.path_to_public_key)
  # private_key = file(var.path_to_private_key)

}

resource "vault_ssh_secret_backend_role" "ssh_role" {

  name                    = "boundary-client"
  backend                 = vault_mount.ssh_mount.path
  key_type                = "ca"
  allow_host_certificates = true
  allow_user_certificates = true
  default_user            = var.default_user
  ttl                     = "180m0s"
  default_extensions = {
    permit-pty = ""
  }
  allowed_users      = "*"
  allowed_extensions = "*"
}


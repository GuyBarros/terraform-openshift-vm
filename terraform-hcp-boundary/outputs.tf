output "boundary_address" {
  value = var.boundary_address
}

output "boundary_auth_string" {
  value = "boundary authenticate password -auth-method-id=${var.boundary_auth_method_id} -login-name=${var.boundary_username} -password=${var.boundary_password}"
}

output "ssh_target" {
  value = boundary_target.backend_servers_ssh.id
}


# SSh
output "zz_boundary_connect_ssh" {
  value = "boundary connect ssh  -target-id  ${boundary_target.backend_servers_ssh.id} --username ubuntu"
}

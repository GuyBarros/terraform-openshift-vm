

# output "boundary-worker" {
#   value = "${kubernetes_service.boundary-worker.status.0.load_balancer.0.ingress.0.hostname}:9201"
# }


output "boundary-cred-ssh-scope-id" {
  value = boundary_credential_library_vault_ssh_certificate.vault_ssh_cert.id
}
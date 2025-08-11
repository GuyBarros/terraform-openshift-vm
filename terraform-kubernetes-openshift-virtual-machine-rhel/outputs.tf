# outputs.tf

output "vm_name" {
  description = "Name of the created virtual machine"
  value       = var.name
}

output "vm_namespace" {
  description = "Namespace of the created virtual machine"
  value       = var.namespace
}

output "vm_default_fqdn" {
  description = "Fully qualified domain name of the VM"
  value       = "${var.name}.${var.namespace}.svc.cluster.local"
}

output "vm_credentials" {
  description = "login credentials"
  value = {
    user     = var.cloud_user
    password = nonsensitive(local.vm_password)
  }
}

output "vm_resources" {
  description = "Configured VM resources"
  value = {
    cpu_total = var.cpu_cores * var.cpu_sockets
    memory    = var.memory
    disk      = var.disk_size
  }
}

# outputs.tf

output "vm_name" {
  description = "Name of the created virtual machine"
  value       = var.name
}

output "vm_namespace" {
  description = "Namespace of the created virtual machine"
  value       = var.namespace
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

output "vm_service_cluster_ip" {
  description = "Primary ClusterIP of the VM service"
  value       = data.kubernetes_service_v1.ssh_internal_service.spec[0].cluster_ip
}

output "vm_service_cluster_ips" {
  description = "Primary ClusterIP of the VM service"
  value       = data.kubernetes_service_v1.ssh_internal_service.spec[0].cluster_ips
}

output "vm_service_hostname" {
  description = "FQDN of the VM Service"
  value       = "${kubectl_manifest.ssh_internal_service.name}.${var.namespace}.svc.cluster.local"
}

output "service_account_binding" {
  description = "Service Account Binding Information"
  value = var.service_account_binding ? {
    enabled              = true
    service_account_name = try(var.service_account_name, null) != null ? var.service_account_name : "${var.name}-sa"
    } : {
    enabled = false
  }
}



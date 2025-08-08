output "vm_name" {
  description = "Name of the created virtual machine"
  value       = kubernetes_manifest.kubevirt_vm.manifest.metadata.name
}

output "vm_namespace" {
  description = "Namespace of the created virtual machine"
  value       = kubernetes_manifest.kubevirt_vm.manifest.metadata.namespace
}

output "vm_resource" {
  description = "Full VM resource manifest"
  value       = kubernetes_manifest.kubevirt_vm.manifest
  sensitive   = true # Since it contains the password
}

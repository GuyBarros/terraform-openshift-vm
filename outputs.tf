#Openshift
output "vm_service_cluster_ip" {
  description = "Primary ClusterIP of the VM service"
  value       = module.openshift-vm.vm_service_cluster_ip
}

output "vm_service_cluster_ips" {
  description = "Primary ClusterIP of the VM service"
  value       = module.openshift-vm.vm_service_cluster_ips
}

output "vm_service_hostname" {
  description = "FQDN of the VM Service"
  value       = module.openshift-vm.vm_service_hostname
}

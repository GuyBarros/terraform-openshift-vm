module "openshift-vm" {
  source                = "./terraform-kubernetes-openshift-virtual-machine-rhel"
  name                  = var.name
  namespace             = var.namespace
  datasource_name       = "rhel9"
  cluster_token         = var.cluster_token
  cluster_api_url       = var.cluster_api_url
  ssh_ca_public_key_uri = var.ssh_ca_public_key_uri

}

module "boundary-target" {
  source                  = "./terraform-hcp-boundary"
  boundary_address        = var.boundary_address
  boundary_auth_method_id = var.boundary_auth_method_id
  boundary_username       = var.boundary_username
  boundary_password       = var.boundary_password
  vault_address           = var.vault_address
  vault_namespace         = var.vault_namespace
  vault_token             = var.vault_token

  vm_address       = module.openshift-vm.vm_service_cluster_ip
  vm_address_alias = module.openshift-vm.vm_service_hostname

  organization_name = var.namespace
  target_name       = var.name
}
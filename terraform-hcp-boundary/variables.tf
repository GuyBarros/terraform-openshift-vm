variable "organization_name" {
  type        = string
  description = "The name of the organization which the target will be associated with"
}

variable "target_name" {
  type        = string
  description = "The name of the organization which the target will be associated with"
}




variable "boundary_address" {
  description = "Boundary Host"
  default     = ""
}

variable "boundary_auth_method_id" {
  description = "Boundary Auth Method"
  default     = ""
}

variable "boundary_username" {
  description = "Boundary Username"
  default     = "admin"
}

variable "boundary_password" {
  description = "Boundary Password"
  default     = ""
}


variable "vm_address" {
  description = "VM Address"
  default     = "172.31.243.230"
}

variable "vm_address_alias" {
  description = "VM Address Alias"
  default     = "test-vm.demo.svc.cluster.local"
}

variable "boundary_cred_ssh_scope_id" {
  description = "Boundary SSH Credential Scope ID"
  default     = ""
}
variable "organization_name" {
  type        = string
  description = "The name of the organization which the target will be associated with"
}

variable "target_name" {
  type        = string
  description = "The name of the organization which the target will be associated with"
}

/// Vault Config 
variable "vault_namespace" {
  description = "the HCP Vault namespace we will use for mounting the database secret engine"
  default     = "admin"
}

variable "vault_address" {
  description = "the Vault Address"
}

variable "vault_token" {
  description = "the Vault Address"
  sensitive   = true
}


variable "cluster_token" {
  description = "Token for Kubernetes cluster authentication"
  type        = string
  default     = ""
}

variable "cluster_api_url" {
  description = "API URL for the Kubernetes cluster"
  type        = string
  default     = ""
}

variable "cluster_insecure_skip_tls_verify" {
  description = "Skip TLS verification for the Kubernetes cluster"
  type        = bool
  default     = true
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


variable "boundary_ingress_worker_count" {
  description = "count of ingress workers do deploy on nomad"
  default     = 3
}

variable "vm_address" {
  description = "VM Address"
  default     = "172.31.243.230"
}

variable "vm_address_alias" {
  description = "VM Address Alias"
  default     = "test-vm.demo.svc.cluster.local"
}
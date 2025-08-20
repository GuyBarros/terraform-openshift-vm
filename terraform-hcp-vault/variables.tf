variable "landing_zone_name" {
  type        = string
  description = "Landing zone identifier for all resources in this project"

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
//// Vault K8s 
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

///// Vault SSH /////
variable "default_user" {
  description = "Default user for SSH certificate"
  type        = string
  default     = "ubuntu"
}

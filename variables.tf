variable "cluster_token" {
  description = "OpenShift cluster authentication token"
  type        = string
  default      = ""
}

variable "cluster_api_url" {
  description = "OpenShift API URL"
  type        = string
  default      = ""
}

variable "cluster_insecure_skip_tls_verify" {
  description = "Skip TLS verification for the OpenShift API"
  type        = bool
  default     = true
}

# Openshift Module
variable "name" {
  description = "Name of the virtual machine (also used as hostname)"
  type        = string
}

variable "namespace" {
  description = "Kubernetes namespace for the VM"
  type        = string
}

variable "ssh_ca_public_key_uri" {
  description = "URI to the SSH CA public key"
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^https?://", var.ssh_ca_public_key_uri))
    error_message = "Invalid SSH CA public key URI. It must start with http:// or https://"
  }
}
# Boundary Target Module


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

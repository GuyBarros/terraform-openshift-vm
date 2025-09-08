variable "landing_zone_name" {
  type        = string
  description = "Landing zone identifier for all resources in this project"
}

variable "hcp_boundary_cluster_id" {
  description = "The HCP Boundary cluster ID"
  type        = string
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

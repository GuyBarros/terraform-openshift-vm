# variables.tf

# Cluster and Authentication Configuration
variable "cluster_token" {
  description = "OpenShift cluster authentication token"
  type        = string
}

variable "cluster_api_url" {
  description = "OpenShift API URL"
  type        = string
}

variable "cluster_insecure_skip_tls_verify" {
  description = "Skip TLS verification for the OpenShift API"
  type        = bool
  default     = true
}

# Core VM Configuration
variable "name" {
  description = "Name of the virtual machine (also used as hostname)"
  type        = string
}

variable "namespace" {
  description = "Kubernetes namespace for the VM"
  type        = string
  default     = "default"
}

variable "service_account_binding" {
  description = "Binds a Service Account identity to the virtual machine. if no Service Account name is provided, a default one will be created."
  type        = bool
  default     = false
}

variable "service_account_name" {
  description = "Name of the Service Account to bind to the VM."
  type        = string
  default     = null
}

# Resource Configuration
variable "cpu_cores" {
  description = "Number of CPU cores per socket"
  type        = number
  default     = 1
}

variable "cpu_sockets" {
  description = "Number of CPU sockets"
  type        = number
  default     = 2
}

variable "cpu_threads" {
  description = "Number of threads per core"
  type        = number
  default     = 1
}

variable "memory" {
  description = "Guest memory allocation (e.g., '4Gi')"
  type        = string
  default     = "4Gi"
}

variable "disk_size" {
  description = "Root disk size (e.g., '30Gi')"
  type        = string
  default     = "30Gi"
}

# VM Source Image
variable "datasource_name" {
  description = "Name of the datasource for the VM image (e.g., rhel9, rhel8, centos-stream9)"
  type        = string
  default     = "rhel9"

  validation {
    condition = contains([
      "rhel9",
      "rhel8",
      "centos-stream9",
      "centos-stream10",
      "fedora"
    ], var.datasource_name)
    error_message = "Invalid OS type. Supported values are: rhel9, rhel8, centos-stream9, centos-stream10, fedora"
  }
}

variable "datasource_namespace" {
  description = "Namespace of the datasource"
  type        = string
  default     = "openshift-virtualization-os-images"
}

# Cloud-Init Configuration
variable "cloud_user" {
  description = "Default cloud-init user"
  type        = string
  default     = "cloud-user"
}

variable "cloud_user_password" {
  description = "Password for the cloud-init user (auto-generated if not provided)"
  type        = string
  default     = ""
  sensitive   = true
}

# VM Metadata/Sizing
variable "size" {
  description = "VM size (small, medium, large)"
  type        = string
  default     = "small"

  validation {
    condition = contains([
      "tiny",
      "small",
      "medium",
      "large"
    ], var.size)
    error_message = "Invalid VM size. Supported values are: tiny, small, medium, large"
  }
}

variable "flavor" {
  description = "VM flavor"
  type        = string
  default     = "small"

  validation {
    condition = contains([
      "tiny",
      "small",
      "medium",
      "large"
    ], var.flavor)
    error_message = "Invalid VM flavor. Supported values are: tiny, small, medium, large"
  }
}

variable "workload" {
  description = "Workload type (server, desktop)"
  type        = string
  default     = "server"

  validation {
    condition = contains([
      "server",
      "desktop",
    ], var.workload)
    error_message = "Invalid workload type. Supported values are: server, desktop"
  }
}

# System Configuration
variable "machine_type" {
  description = "QEMU machine type"
  type        = string
  default     = "pc-q35-rhel9.4.0"
}

variable "run_strategy" {
  description = "VM run strategy (Halted, RerunOnFailure, Always)"
  type        = string
  default     = "RerunOnFailure"

  validation {
    condition = contains([
      "Halted",
      "RerunOnFailure",
      "Always"
    ], var.run_strategy)
    error_message = "Invalid VM run strategy. Supported values are: Halted, RerunOnFailure, Always"
  }
}

# VM SSH Configuration
variable "ssh_ca_public_key_uri" {
  description = "URI to the SSH CA public key"
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^https?://", var.ssh_ca_public_key_uri))
    error_message = "Invalid SSH CA public key URI. It must start with http:// or https://"
  }
}

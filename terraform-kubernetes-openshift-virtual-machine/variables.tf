# variables.tf

variable "vm_name" {
  description = "Name of the virtual machine"
  type        = string
  default     = "rhel9-salmon-goat-20"
}

variable "namespace" {
  description = "Kubernetes namespace for the VM"
  type        = string
  default     = "default"
}

variable "folder" {
  description = "VM folder for organization"
  type        = string
  default     = "RHEL"
}

# CPU Configuration
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

# Memory Configuration
variable "memory" {
  description = "Guest memory allocation (e.g., '4Gi')"
  type        = string
  default     = "4Gi"
}

variable "min_memory_bytes" {
  description = "Minimum required memory in bytes"
  type        = number
  default     = 1610612736
}

# Storage Configuration
variable "disk_size" {
  description = "Root disk size (e.g., '30Gi')"
  type        = string
  default     = "30Gi"
}

variable "disk_bus" {
  description = "Disk bus type"
  type        = string
  default     = "virtio"
}

variable "datasource_name" {
  description = "Name of the datasource for the VM image"
  type        = string
  default     = "rhel9"
}

variable "datasource_namespace" {
  description = "Namespace of the datasource"
  type        = string
  default     = "openshift-virtualization-os-images"
}

# Network Configuration
variable "mac_address" {
  description = "MAC address for the network interface"
  type        = string
  default     = "02:cf:43:00:00:06"
}

variable "network_model" {
  description = "Network interface model"
  type        = string
  default     = "virtio"
}

variable "headless_service" {
  description = "Headless service label value"
  type        = string
  default     = "headless"
}

# Cloud-Init Configuration
variable "cloud_user" {
  description = "Default cloud-init user"
  type        = string
  default     = "cloud-user"
}

variable "cloud_password" {
  description = "Initial cloud-init password"
  type        = string
  default     = "2i45-qmh5-ypyo"
  sensitive   = true
}

variable "password_expire" {
  description = "Whether the cloud-init password expires"
  type        = bool
  default     = false
}

# VM Template Configuration
variable "vm_template" {
  description = "VM template name"
  type        = string
  default     = "rhel9-server-small"
}

variable "vm_template_namespace" {
  description = "VM template namespace"
  type        = string
  default     = "openshift"
}

variable "vm_template_revision" {
  description = "VM template revision"
  type        = string
  default     = "1"
}

variable "vm_template_version" {
  description = "VM template version"
  type        = string
  default     = "v0.32.2"
}

variable "vm_flavor" {
  description = "VM flavor"
  type        = string
  default     = "small"
}

variable "vm_os" {
  description = "Operating system"
  type        = string
  default     = "rhel9"
}

variable "vm_workload" {
  description = "Workload type"
  type        = string
  default     = "server"
}

variable "vm_size" {
  description = "VM size designation"
  type        = string
  default     = "small"
}

# System Configuration
variable "architecture" {
  description = "CPU architecture"
  type        = string
  default     = "amd64"
}

variable "machine_type" {
  description = "Machine type"
  type        = string
  default     = "pc-q35-rhel9.4.0"
}

variable "run_strategy" {
  description = "VM run strategy"
  type        = string
  default     = "RerunOnFailure"
}

variable "termination_grace_period" {
  description = "Termination grace period in seconds"
  type        = number
  default     = 180
}

variable "dynamic_credentials_support" {
  description = "Enable dynamic credentials support"
  type        = bool
  default     = true
}

variable "smm_enabled" {
  description = "Enable SMM feature"
  type        = bool
  default     = true
}

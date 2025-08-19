# main.tf
# Generate a random password if not provided
resource "random_password" "vm_password" {
  count            = var.cloud_user_password == "" ? 1 : 0
  length           = 16
  special          = true
  override_special = "_@-!$%^"
  upper            = true
  lower            = true
  numeric          = true
}

# Local value to use either provided or generated password
locals {
  vm_password = var.cloud_user_password != "" ? var.cloud_user_password : random_password.vm_password[0].result
}

# Create service account if binding is enabled and no custom name is provided
resource "kubectl_manifest" "service_account" {
  count = var.service_account_binding && try(var.service_account_name, null) == null ? 1 : 0

  yaml_body = yamlencode({
    apiVersion = "v1"
    kind       = "ServiceAccount"
    metadata = {
      name      = "${var.name}-sa"
      namespace = var.namespace
    }
  })
}

resource "kubectl_manifest" "kubevirt_vm" {
  yaml_body = templatefile("${path.module}/templates/rhel.yaml.tftpl", {
    # Core identifiers
    name      = var.name
    namespace = var.namespace

    # Service Account bindings
    service_account_binding = var.service_account_binding
    service_account_name    = try(var.service_account_name, null) != null ? var.service_account_name : "${var.name}-sa"

    # Resource configuration
    cpu_cores   = var.cpu_cores
    cpu_sockets = var.cpu_sockets

    cpu_threads = var.cpu_threads
    memory      = var.memory
    disk_size   = var.disk_size

    # VM source
    datasource_name      = var.datasource_name
    datasource_namespace = var.datasource_namespace

    # Cloud-init
    cloud_user          = var.cloud_user
    cloud_user_password = local.vm_password

    # VM characteristics
    size     = var.size
    flavor   = var.flavor
    workload = var.workload

    # System configuration
    machine_type = var.machine_type
    run_strategy = var.run_strategy
  })
}


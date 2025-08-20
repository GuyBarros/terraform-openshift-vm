data "kubernetes_service_v1" "ssh_internal_service" {
  metadata {
    name      = kubectl_manifest.ssh_internal_service.name
    namespace = kubectl_manifest.ssh_internal_service.namespace
  }
}

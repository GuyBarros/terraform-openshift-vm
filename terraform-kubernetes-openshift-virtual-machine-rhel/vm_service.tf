resource "kubernetes_service" "vm-service" {
  depends_on = [kubectl_manifest.kubevirt_vm]
  metadata {
    name = "kubevirt-vm-service"
    labels = {
      app = var.name
    }
    namespace = var.namespace
  }

  spec {
    type = "ClusterIP"
    selector = {
      app = var.name
    }

    port {
      name        = "ssh"
      port        = 22
      target_port = 22
    }

  }
}

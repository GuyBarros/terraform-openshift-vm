resource "kubernetes_namespace_v1" "openshift" {
  metadata {
    name = var.landing_zone_name
    labels = {
      managedBy  = "Terraform"
      securedBy  = "Vault"
      accessedBy = "Boundary"
    }
  }
}

resource "kubernetes_service_account_v1" "vm-deployer" {
  metadata {
    name      = "vm-deployer-service-account"
    namespace = kubernetes_namespace_v1.openshift.metadata[0].name
  }
}

resource "kubernetes_role_binding_v1" "vm-deployer" {
  metadata {
    name      = "${kubernetes_service_account_v1.vm-deployer.metadata[0].name}-role-binding"
    namespace = kubernetes_namespace_v1.openshift.metadata[0].name
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "admin"
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account_v1.vm-deployer.metadata[0].name
    namespace = kubernetes_namespace_v1.openshift.metadata[0].name
  }
}

resource "kubernetes_service_account_v1" "hcp-vault" {
  metadata {
    name      = "hcp-vault-service-account"
    namespace = kubernetes_namespace_v1.openshift.metadata[0].name
  }
}

resource "kubernetes_cluster_role_binding_v1" "hcp-vault" {
  metadata {
    name = "${kubernetes_service_account_v1.hcp-vault.metadata[0].name}-cluster-role-binding"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account_v1.hcp-vault.metadata[0].name
    namespace = kubernetes_namespace_v1.openshift.metadata[0].name
  }
}

resource "kubernetes_secret_v1" "openshift" {
  metadata {
    name      = "${kubernetes_service_account_v1.hcp-vault.metadata[0].name}-token"
    namespace = kubernetes_namespace_v1.openshift.metadata[0].name
    annotations = {
      "kubernetes.io/service-account.name" = kubernetes_service_account_v1.hcp-vault.metadata[0].name
    }
  }
  wait_for_service_account_token = true
  type                           = "kubernetes.io/service-account-token"
}


resource "vault_kubernetes_secret_backend" "openshift" {

  path                      = "openshift"
  description               = "Vend OpenShift Service Account tokens"
  default_lease_ttl_seconds = 1800
  max_lease_ttl_seconds     = 3600
  kubernetes_host           = var.cluster_api_url
  kubernetes_ca_cert        = kubernetes_secret_v1.openshift.data["ca.crt"]
  service_account_jwt       = kubernetes_secret_v1.openshift.data["token"]
  disable_local_ca_jwt      = false
}

resource "vault_kubernetes_secret_backend_role" "openshift" {

  backend                       = vault_kubernetes_secret_backend.openshift.path
  name                          = "vm-deployment-role"
  allowed_kubernetes_namespaces = ["${kubernetes_namespace_v1.openshift.metadata[0].name}"]
  token_max_ttl                 = 3600
  token_default_ttl             = 1200
  service_account_name          = kubernetes_service_account_v1.vm-deployer.metadata[0].name
}

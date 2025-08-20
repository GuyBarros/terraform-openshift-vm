provider "kubernetes" {
  # config_path    = "~/.kube/config"
  token    = var.cluster_token
  host     = var.cluster_api_url
  insecure = var.cluster_insecure_skip_tls_verify
}

provider "boundary" {
  addr                   = var.boundary_address
  auth_method_login_name = var.boundary_username
  auth_method_password   = var.boundary_password
  auth_method_id         = var.boundary_auth_method_id
}

resource "boundary_worker" "controller_led" {
  scope_id    = "global"
  name        = "${var.landing_zone_name}-ingress-worker"
  description = "self managed worker with controller led auth"
}

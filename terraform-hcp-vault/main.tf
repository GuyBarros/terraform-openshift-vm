provider "kubernetes" {
  # config_path    = "~/.kube/config"
  token    = var.cluster_token
  host     = var.cluster_api_url
  insecure = var.cluster_insecure_skip_tls_verify
}


provider "vault" {
  
}


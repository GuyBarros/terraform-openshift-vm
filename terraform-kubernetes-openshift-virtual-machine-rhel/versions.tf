terraform {
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~> 1.19"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.7"
    }
    http = {
      source  = "hashicorp/http"
      version = "~> 3.5"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.38"
    }
  }
}

provider "kubectl" {
  # config_path    = "~/.kube/config"
  token    = var.cluster_token
  host     = var.cluster_api_url
  insecure = var.cluster_insecure_skip_tls_verify
  load_config_file = false
}

provider "kubernetes" {
  # config_path    = "~/.kube/config"
  token    = var.cluster_token
  host     = var.cluster_api_url
  insecure = var.cluster_insecure_skip_tls_verify
}


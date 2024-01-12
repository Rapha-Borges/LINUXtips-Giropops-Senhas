terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "5.23.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.25.2"
    }
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}
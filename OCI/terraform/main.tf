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

provider "oci" {
  region                = var.region
  tenancy_ocid          = var.tenancy_ocid
  user_ocid             = var.user_ocid
  fingerprint           = var.fingerprint
  private_key_path      = var.private_key_path
  config_file_profile   = var.oci_profile 
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}
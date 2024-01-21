# ----------> Compartment <----------

variable "compartment_name" {
  type    = string
  default = "k8s-arm"
}

variable "region" {
  type    = string
  default = "sa-saopaulo-1"  
}

variable "availability_domain" {
  type    = number
  default = 0
}

# ---------->VM's----------

variable "shape" {
  type    = string
  default = "VM.Standard.A1.Flex"
}

variable "ocpus_per_node" {
  type    = number
  default = 1
}

variable "memory_in_gbs_per_node" {
  type    = number
  default = 6
}

variable "image_id" {
  type    = string
  default = "ocid1.image.oc1.sa-saopaulo-1.aaaaaaaaeo34cgln3nvq44nmcckxdwzu7xccswpm56koo7ofox7vaphislpa"
}
# Link to a list of available images (We are using Oracle-Linux-8.8-aarch64-2023.12.13-0, allways use the ARM version): https://docs.cloud.oracle.com/iaas/images/

# ----------> Cluster <----------
variable "k8s_version" {
  type    = string
  default = "v1.28.2"
}

variable "node_size" {
  type    = string
  default = "3"
}

variable "cluster_name" {
  type    = string
  default = "k8s-cluster"
}

# ----------> Network <----------

variable "vcn_name" {
  type    = string
  default = "k8s-vcn"  
}

variable "vcn_dns_label" {
  type    = string
  default = "k8svcn"  
}

# ----------> Load Balancer <----------

variable "load_balancer_name_space" {
  type    = string
  default = "loadbalancer"
}

# ----------> Authentication <----------

variable "ssh_public_key" {
  type    = string
}

variable "fingerprint" {
  type    = string
}

variable "private_key_path" {
  type    = string
}

variable "tenancy_ocid" {
  type    = string
}

variable "user_ocid" {
  type    = string
}

variable "oci_profile" {
  type    = string
  default = "PICK"
}
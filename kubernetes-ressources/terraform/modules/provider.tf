variable "MOD_REGION" {
  description = "The region where the infra must be provisioned"
}

variable "MOD_COUNT" {
  description = "The number of pair (GKE cluster + bastion instance)"
}

variable "MOD_PROJECT" {
}

provider "google" {
  project = var.MOD_PROJECT
  region  = var.MOD_REGION
}

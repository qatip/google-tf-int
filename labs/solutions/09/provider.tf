provider "google" {
  project = "lbg-training-mcg"
  region  = "europe-west2"
}

data "google_client_config" "default" {}

provider "kubernetes" {
  host                   = "https://${google_container_cluster.gke.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(google_container_cluster.gke.master_auth.0.cluster_ca_certificate)
}

#provider "helm" {
#  kubernetes {
#    host                   = google_container_cluster.gke.endpoint
#    token                  = data.google_client_config.default.access_token
#    cluster_ca_certificate = base64decode(google_container_cluster.gke.master_auth.0.cluster_ca_certificate)
#  }
#}
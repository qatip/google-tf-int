resource "google_container_cluster" "gke" {
  name     = "lab1-gke-cluster"
  location = "europe-west2-a"  # Zonal Cluster

  remove_default_node_pool = true
  initial_node_count       = 1

  # Deletion protection disabled
  deletion_protection      = false
}

resource "google_container_node_pool" "primary_nodes" {
  name       = "primary-node-pool"
  cluster    = google_container_cluster.gke.name
  location   = google_container_cluster.gke.location

  node_config {
    preemptible  = false
    machine_type = "e2-small"
  }

  initial_node_count = 2
}
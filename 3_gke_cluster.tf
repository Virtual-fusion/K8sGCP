# Create GKE Cluster
#====================
resource "google_container_cluster" "primary" {
  name                     = "dev-cluster"
  location                 = "europe-west1"
  remove_default_node_pool = true
  initial_node_count       = 1
  network                  = google_compute_network.main.self_link
  subnetwork               = google_compute_subnetwork.private.self_link
  networking_mode          = "VPC_NATIVE"
  deletion_protection      = false

  # Multi-zonal cluster: Specify additional zones if desired
  node_locations = [
    "europe-west1-b", 
    "europe-west1-c"  # Add additional zones as required
  ]

  addons_config {
    http_load_balancing {
      disabled = true
    }
    horizontal_pod_autoscaling {
      disabled = false
    }
  }

  release_channel {
    channel = "REGULAR"
  }

  # Optional: Uncomment if workload identity is required
  # workload_identity_config {
  #   workload_pool = "Host-project.svc.id.goog"
  # }

  ip_allocation_policy {
    cluster_secondary_range_name  = "k8s-pod-range"
    services_secondary_range_name = "k8s-service-range"
  }

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = "172.16.0.0/28"  # Ensure no overlap with VPC ranges
  }
}

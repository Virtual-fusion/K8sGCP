# Create a VPC
#===============
resource "google_compute_network" "main" {
  name                            = "pcidss-vpc"
  routing_mode                    = "REGIONAL"
  auto_create_subnetworks         = false
  mtu                             = 1460
  delete_default_routes_on_create = false
}

# Create Subnet
#===============
resource "google_compute_subnetwork" "private" {
  name                     = "private"
  ip_cidr_range            = "10.0.0.0/18"
  region                   = "europe-west1"
  network                  = google_compute_network.main.id
  private_ip_google_access = true

  secondary_ip_range {
    range_name    = "k8s-pod-range"
    ip_cidr_range = "10.48.0.0/14"
  }
  secondary_ip_range {
    range_name    = "k8s-service-range"
    ip_cidr_range = "10.52.0.0/20"
  }
}

# Create Router
#===============
resource "google_compute_router" "router" {
  name    = "router"
  region  = "europe-west1"
  network = google_compute_network.main.id
}

# NAT Creation
#===============
resource "google_compute_router_nat" "nat" {
  name   = "vfusion-nat"
  router = google_compute_router.router.name
  region = "europe-west1"

  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  nat_ip_allocate_option             = "MANUAL_ONLY"

  subnetwork {
    name                    = google_compute_subnetwork.private.id
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }

  nat_ips = [google_compute_address.nat.self_link]
}

# Assign NAT an External IP Address
#====================================
resource "google_compute_address" "nat" {
  name         = "vfusion-nat"
  address_type = "EXTERNAL"
  network_tier = "PREMIUM"
  region       = "europe-west1"  # Added region to match NAT's region
}

# Create a Firewall Rule
#========================
resource "google_compute_firewall" "allow-ssh" {
  name    = "allow-ssh"
  network = google_compute_network.main.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]  # Consider restricting this for security
}

resource "google_compute_network" "lz_hub_vpc" {
  name                    = "lz-hub-vpc"
  project                 = var.project_id
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "lz_private_subnet_a" {
  name                     = "lz-private-subnet-a"
  project                  = var.project_id
  ip_cidr_range            = "10.10.1.0/24"
  region                   = "asia-south1"
  network                  = google_compute_network.lz_hub_vpc.self_link
  private_ip_google_access = true

  log_config {
    aggregation_interval = "INTERVAL_5_MIN"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
}

resource "google_compute_subnetwork" "lz_private_subnet_b" {
  name                     = "lz-private-subnet-b"
  project                  = var.project_id
  ip_cidr_range            = "10.10.2.0/24"
  region                   = "asia-south1"
  network                  = google_compute_network.lz_hub_vpc.self_link
  private_ip_google_access = true

  log_config {
    aggregation_interval = "INTERVAL_5_MIN"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
}

resource "google_compute_router" "lz_router" {
  name    = "lz-hub-router"
  project = var.project_id
  region  = "asia-south1"
  network = google_compute_network.lz_hub_vpc.self_link
}

resource "google_compute_router_nat" "lz_nat" {
  name                               = "lz-hub-nat"
  project                            = var.project_id
  router                             = google_compute_router.lz_router.name
  region                             = "asia-south1"
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  subnetwork {
    name                    = google_compute_subnetwork.lz_private_subnet_a.self_link
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }

  subnetwork {
    name                    = google_compute_subnetwork.lz_private_subnet_b.self_link
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
}

resource "google_compute_firewall" "deny_all_ingress" {
  name      = "lz-deny-all-ingress"
  project   = var.project_id
  network   = google_compute_network.lz_hub_vpc.name
  direction = "INGRESS"
  priority  = 65535

  source_ranges = ["0.0.0.0/0"]

  deny {
    protocol = "all"
  }

  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }
}

resource "google_compute_firewall" "allow_ssh_internal" {
  name          = "lz-allow-ssh-internal"
  project       = var.project_id
  network       = google_compute_network.lz_hub_vpc.name
  source_ranges = ["10.10.0.0/16"]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }
}

resource "google_compute_firewall" "allow_all_egress" {
  name               = "lz-allow-all-egress"
  project            = var.project_id
  network            = google_compute_network.lz_hub_vpc.name
  direction          = "EGRESS"
  destination_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "all"
  }
}

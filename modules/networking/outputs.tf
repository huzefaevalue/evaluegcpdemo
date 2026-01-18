output "vpc_name" {
  value = google_compute_network.lz_hub_vpc.name
}

output "subnet_a_self_link" {
  value = google_compute_subnetwork.lz_private_subnet_a.self_link
}

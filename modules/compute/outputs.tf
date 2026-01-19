output "vm_private_ip" {
  value = google_compute_instance.lz_test_vm.network_interface[0].network_ip
}

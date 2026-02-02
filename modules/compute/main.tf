data "google_compute_image" "debian" {
  family  = var.vm_image_family
  project = var.vm_image_project
}

resource "google_compute_instance" "lz_test_vm" {
  name         = var.vm_name
  machine_type = var.vm_machine_type
  zone         = var.vm_zone

  boot_disk {
    initialize_params {
      image = data.google_compute_image.debian.self_link
    }
  }

  network_interface {
    subnetwork = var.subnet_self_link
  }

  service_account {
    email  = var.runtime_sa_email
    scopes = ["cloud-platform"]
  }

  shielded_instance_config {
    enable_secure_boot          = true
    enable_vtpm                 = true
    enable_integrity_monitoring = true
  }

  metadata_startup_script = <<-EOF
    #!/bin/bash
    echo "landing zone ready" | logger -t lz-test-vm-startup
  EOF
}

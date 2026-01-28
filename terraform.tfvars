# Project & Contact
project_id         = "eighth-effect-484111-f5"
notification_email = "shaikhuzefa1995@gmail.com"

# NETWORKING NAMES & CIDRS
vpc_name              = "lz-hub-vpc"
subnet_a_name         = "lz-private-subnet-a"
subnet_a_cidr         = "10.10.1.0/24"
subnet_b_name         = "lz-private-subnet-b"
subnet_b_cidr         = "10.10.2.0/24"
router_name           = "lz-hub-router"
nat_name              = "lz-hub-nat"
vpc_internal_cidr     = "10.10.0.0/16"
deny_all_fw_name      = "lz-deny-all-ingress"
ssh_internal_fw_name  = "lz-allow-ssh-internal"
egress_all_fw_name    = "lz-allow-all-egress"

# IAM SERVICE ACCOUNTS
admin_sa_name     = "lz-admin-sa"
runtime_sa_name   = "lz-runtime-sa"
monitoring_sa_name = "lz-monitoring-sa"

# COMPUTE VM
vm_name           = "lz-test-vm"
vm_zone           = "asia-south1-a"
vm_machine_type   = "e2-micro"
vm_image_family   = "debian-12"
vm_image_project  = "debian-cloud"

# LOGGING BUCKET
logs_bucket_name = "lz-logs-bucket"

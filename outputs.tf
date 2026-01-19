output "vm_private_ip" {
  value = module.compute.vm_private_ip
}

output "vpc_name" {
  value = module.networking.vpc_name
}

output "dashboard_url" {
  value = module.logging_monitoring.dashboard_url
}

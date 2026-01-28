module "networking" {
  source = "./modules/networking"
  
  project_id             = var.project_id
  vpc_name               = var.vpc_name
  subnet_a_name          = var.subnet_a_name
  subnet_a_cidr          = var.subnet_a_cidr
  subnet_b_name          = var.subnet_b_name
  subnet_b_cidr          = var.subnet_b_cidr
  router_name            = var.router_name
  nat_name               = var.nat_name
  vpc_internal_cidr      = var.vpc_internal_cidr
  deny_all_fw_name       = var.deny_all_fw_name
  ssh_internal_fw_name   = var.ssh_internal_fw_name
  egress_all_fw_name     = var.egress_all_fw_name
}

module "iam" {
  source = "./modules/iam"
  
  project_id           = var.project_id
  admin_sa_name        = var.admin_sa_name
  runtime_sa_name      = var.runtime_sa_name
  monitoring_sa_name   = var.monitoring_sa_name
  depends_on           = [module.networking]
}

module "logging_monitoring" {
  source = "./modules/logging-monitoring"
  
  project_id         = var.project_id
  notification_email = var.notification_email
  logs_bucket_name   = var.logs_bucket_name
  depends_on         = [module.iam]
}

module "compute" {
  source = "./modules/compute"
  
  project_id         = var.project_id
  vm_name            = var.vm_name
  vm_zone            = var.vm_zone
  vm_machine_type    = var.vm_machine_type
  vm_image_family    = var.vm_image_family
  vm_image_project   = var.vm_image_project
  subnet_self_link   = module.networking.subnet_a_self_link
  runtime_sa_email   = module.iam.runtime_sa_email
  depends_on         = [module.logging_monitoring]
}

module "networking" {
  source     = "./modules/networking"
  project_id = var.project_id
}

module "iam" {
  source     = "./modules/iam"
  project_id = var.project_id
  depends_on = [module.networking]
}

module "logging_monitoring" {
  source              = "./modules/logging-monitoring"
  project_id          = var.project_id
  notification_email  = var.notification_email
  depends_on          = [module.iam]
}

module "compute" {
  source            = "./modules/compute"
  project_id        = var.project_id
  subnet_self_link  = module.networking.subnet_a_self_link
  runtime_sa_email  = module.iam.runtime_sa_email
  depends_on        = [module.logging_monitoring]
}

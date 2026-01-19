resource "google_service_account" "lz_admin_sa" {
  account_id   = "lz-admin-sa"
  display_name = "LZ Admin Service Account"
}

resource "google_service_account" "lz_runtime_sa" {
  account_id   = "lz-runtime-sa"
  display_name = "LZ Runtime Service Account"
}

resource "google_service_account" "lz_monitoring_sa" {
  account_id   = "lz-monitoring-sa"
  display_name = "LZ Monitoring Service Account"
}

resource "google_project_iam_member" "lz_admin_compute_admin" {
  project = var.project_id
  role    = "roles/compute.admin"
  member  = "serviceAccount:${google_service_account.lz_admin_sa.email}"
}

resource "google_project_iam_member" "lz_admin_service_account_user" {
  project = var.project_id
  role    = "roles/iam.serviceAccountUser"
  member  = "serviceAccount:${google_service_account.lz_admin_sa.email}"
}

resource "google_project_iam_member" "lz_admin_project_iam_admin" {
  project = var.project_id
  role    = "roles/resourcemanager.projectIamAdmin"
  member  = "serviceAccount:${google_service_account.lz_admin_sa.email}"
}

resource "google_project_iam_member" "lz_monitoring_logging_admin" {
  project = var.project_id
  role    = "roles/logging.admin"
  member  = "serviceAccount:${google_service_account.lz_monitoring_sa.email}"
}

resource "google_project_iam_member" "lz_monitoring_monitoring_admin" {
  project = var.project_id
  role    = "roles/monitoring.admin"
  member  = "serviceAccount:${google_service_account.lz_monitoring_sa.email}"
}

resource "google_compute_project_metadata" "os_login" {
  metadata = {
    enable-oslogin = "TRUE"
  }
}

resource "google_project_service" "required_apis" {
  for_each = toset([
    "compute.googleapis.com",
    "logging.googleapis.com",
    "monitoring.googleapis.com",
    "storage.googleapis.com",
    "cloudresourcemanager.googleapis.com"
  ])
  project                    = var.project_id
  service                    = each.key
  disable_dependent_services = false
}

resource "google_storage_bucket" "lz_logs_bucket" {
  name                        = var.logs_bucket_name
  location                    = "asia-south1"
  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"
  force_destroy               = true
}

resource "google_monitoring_notification_channel" "lz_email_channel" {
  display_name = "LZ Alert Notifications"
  type         = "email"
  
  labels = {
    email_address = var.notification_email
  }
}

resource "google_monitoring_alert_policy" "vm_high_cpu" {
  display_name = "VM CPU > 80% for 5 minutes"
  
  combiner = "OR"

  conditions {
    display_name = "High CPU usage"
    condition_threshold {
      filter          = "resource.type=\"gce_instance\" AND metric.type=\"compute.googleapis.com/instance/cpu/utilization\""
      comparison      = "COMPARISON_GT"
      threshold_value = 0.8
      duration        = "300s"
      
      aggregations {
        alignment_period   = "300s"
        per_series_aligner = "ALIGN_MEAN"
      }
    }
  }
  
  notification_channels = [
    google_monitoring_notification_channel.lz_email_channel.id
  ]
}

resource "google_monitoring_dashboard" "lz_dashboard" {
  dashboard_json = file("${path.module}/dashboard.json")
}

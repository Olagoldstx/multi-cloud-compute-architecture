##################################################
# SecureTheCloud — GCP Monitoring & Security
##################################################

provider "google" {
  project = var.project
  region  = var.region
}

###############################################
# 1. Enable Security Command Center (SCC)
###############################################

resource "google_scc_source" "stc" {
  display_name = "${var.prefix}-scc-source"
}

###############################################
# 2. Enable VPC Flow Logs
###############################################

resource "google_compute_subnetwork" "flow_logs" {
  name          = "stc-flowlogs"
  ip_cidr_range = "10.40.0.0/24"
  region        = var.region
  network       = var.network

  log_config {
    aggregation_interval = "INTERVAL_5_SEC"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
}

###############################################
# 3. Enable LB Logging (HTTPS LB)
###############################################

resource "google_compute_backend_service" "logging" {
  name     = "${var.prefix}-lb-logging"
  log_config {
    enable = true
  }
}

###############################################
# 4. Cloud Logging Log Sink
###############################################

resource "google_logging_project_sink" "sink" {
  name                  = "${var.prefix}-sink"
  destination           = "storage.googleapis.com/${var.bucket_name}"
  filter                = "severity>=ERROR"
  include_children      = true
  unique_writer_identity = true
}

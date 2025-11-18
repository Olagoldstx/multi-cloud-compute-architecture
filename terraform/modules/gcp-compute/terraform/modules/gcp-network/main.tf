##################################################
# SecureTheCloud — GCP Zero Trust Network Module
##################################################

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

###############################################
# Zero Trust Firewall — DENY ALL INGRESS
###############################################

resource "google_compute_firewall" "deny_all" {
  name    = "gcp-zero-trust-deny-all"
  network = var.network

  direction = "INGRESS"
  priority  = 1000

  denies {
    protocol = "all"
  }

  source_ranges = ["0.0.0.0/0"]
}

###############################################
# Allow ONLY outbound to Google APIs
###############################################

resource "google_compute_firewall" "allow_google_apis" {
  name    = "gcp-zero-trust-allow-google-apis"
  network = var.network

  direction = "EGRESS"
  priority  = 100

  allows {
    protocol = "tcp"
    ports    = ["443"]
  }

  destination_ranges = ["199.36.153.8/30"] # Google Private Access
}

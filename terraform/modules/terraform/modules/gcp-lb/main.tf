##################################################
# SecureTheCloud — GCP HTTPS Load Balancer
##################################################

resource "google_compute_global_address" "lb_ip" {
  name = "${var.name}-ip"
}

resource "google_compute_health_check" "http_health" {
  name               = "${var.name}-health"
  timeout_sec        = 5
  check_interval_sec = 5

  http_health_check {
    port = 80
  }
}

resource "google_compute_backend_service" "backend" {
  name          = "${var.name}-backend"
  health_checks = [google_compute_health_check.http_health.self_link]
}

resource "google_compute_url_map" "urlmap" {
  name            = "${var.name}-urlmap"
  default_service = google_compute_backend_service.backend.self_link
}

resource "google_compute_target_http_proxy" "http_proxy" {
  name    = "${var.name}-proxy"
  url_map = google_compute_url_map.urlmap.self_link
}

resource "google_compute_global_forwarding_rule" "forwarding_rule" {
  name                  = "${var.name}-forwarding-rule"
  ip_address            = google_compute_global_address.lb_ip.address
  port_range            = "80"
  target                = google_compute_target_http_proxy.http_proxy.self_link
  load_balancing_scheme = "EXTERNAL"
}

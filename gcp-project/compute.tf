resource "google_compute_network" "my-network" {
  name    = "my-network"
  project = google_project_service.default_services["compute.googleapis.com"].project
}

resource "google_compute_firewall" "my-network-allow-ssh-broad" {
  name    = "my-network-allow-ssh-broad"
  network = google_compute_network.my-network.name
  project = google_compute_network.my-network.project

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = [
    "69.173.112.0/21",
    "69.173.120.0/22",
    "69.173.126.0/24",
    "69.173.127.0/25",
    "69.173.127.128/26",
    "69.173.127.192/27",
    "69.173.127.224/30",
    "69.173.127.228/32",
    "69.173.127.230/31",
    "69.173.127.232/29",
    "69.173.127.240/28",
    "69.173.64.0/19",
    "69.173.96.0/20",
  ]

  target_tags = [
    "ssh-broad"
  ]
}

resource "google_compute_address" "my-instance" {
  name    = "my-instance-ip"
  region  = var.region
  project = google_compute_network.my-network.project
}

resource "google_compute_disk" "my-instance-boot" {
  name    = "my-instance-boot"
  type    = "pd-standard"
  image   = var.image
  size    = 20
  project = google_compute_network.my-network.project
  zone    = var.zone
}

resource "google_compute_instance" "my-instance" {
  name          = "my-instance"
  machine_type  = var.machine_type
  project       = google_compute_disk.my-instance-boot.project
  zone          = var.zone

  allow_stopping_for_update = true

  tags = [
    "ssh-broad",
  ]

  boot_disk {
    auto_delete = false
    source      = google_compute_disk.my-instance-boot.id
  }

  network_interface {
    network            = google_compute_network.my-network.self_link
    access_config {
      nat_ip           = google_compute_address.my-instance.address
      network_tier     = "PREMIUM"
    }
  }

  service_account {
    email  = google_service_account.compute.email
    scopes = ["monitoring"]
  }
}

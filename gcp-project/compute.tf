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

  source_ranges = jsondecode(data.google_storage_bucket_object_content.internal_networks.content)

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

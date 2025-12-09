terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = "us-west1"
  zone    = "us-west1-a"
}

resource "google_compute_network" "vpc" {
  name                    = "demo-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  name          = "demo-subnet"
  ip_cidr_range = "10.0.0.0/24"
  region        = "us-west1"
  network       = google_compute_network.vpc.id
}

resource "google_compute_instance" "vm" {
  name         = "demo-vm"
  machine_type = "e2-micro"
  zone         = "us-west1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.subnet.id

    access_config {
      // ephemeral public IP
    }
  }
}

output "vm_id" {
  value = google_compute_instance.vm.id
}

output "vm_self_link" {
  value = google_compute_instance.vm.self_link
}

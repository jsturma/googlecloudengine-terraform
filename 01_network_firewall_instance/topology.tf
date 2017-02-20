provider "google" {
  project = "${var.projectf_id}"
  region      = "${var.region}"
  credentials = "${file("../../key.json")}"
}


resource "google_compute_network" "default" {
  name                    = "custom-network1"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "subnet1" {
  name          = "subnet1"
  ip_cidr_range = "192.168.0.0/24"
  network       = "${google_compute_network.default.self_link}"
}

resource "google_compute_firewall" "http-nginx" {
  name    = "http-nginx"
  network = "${google_compute_network.default.name}"

  source_ranges=["0.0.0.0/0"]
  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
}

resource "google_compute_firewall" "ssh-nginx" {
  name    = "ssh-nginx"
  network = "${google_compute_network.default.name}"
  source_ranges=["0.0.0.0/0"]
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}


resource "google_compute_instance" "nginx" {
  name         = "nginx"
  machine_type = "n1-standard-1"
  tags = ["nginx"]
  metadata_startup_script = "${file("../startup_script/init_script.sh")}"
  disk {
    image = "debian-cloud/debian-8"
  }

  zone  = "${var.zone}"

  network_interface {
    subnetwork = "${google_compute_subnetwork.subnet1.name}"
    access_config {
      // Ephemeral IP
    }
  }
}
output "nginx-loadbalancer-public_ip" {
  value = "${google_compute_instance.nginx.network_interface.0.access_config.0.assigned_nat_ip}"
}

provider "google" {
  region = "${var.region}"
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

resource "google_container_cluster" "my-cluster" {
  name               = "my-cluster"
  zone               = "europe-west1-b"
  initial_node_count = 2
  network            = "${google_compute_network.default.self_link}"
  subnetwork         = "${google_compute_subnetwork.subnet1.name}"

  additional_zones = [
    "europe-west1-c",
    "europe-west1-d",
  ]

  master_auth {
    username = "admin_01"
    password = "changeme"
  }

  node_config {
    machine_type = "n1-standard-1"

    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}

output "cluster_endpoint" {
  value = "${google_container_cluster.my-cluster.endpoint}"
}

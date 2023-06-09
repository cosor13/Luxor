Setup Project in GCP account/create bucket
main.tf

```module"account_setup"{
  source ="./module"
  account_setup ={
    billing_account_name ="My Billing Account"
    project_name         ="luxor"
    bucket_name          ="luxor"
  }
}
backend.tf

terraform {
  backend "gcs" {
    bucket = "luxor"
    prefix = "1.project_setup"
  }
}
output.tf

output"project_id"{
  value =google_project.luxor.id
}
output"project_name"{
  value =google_project.luxor.name
}
output"bucketname"{
  value =nonsensitive(google_storage_bucket.backend-luxor.name)
}

2. Create Cluster GKE

```cluster.tf

provider "google" {
  region = var.gke_config["region"]
  zone   = var.gke_config["zone"]
}
data "google_container_engine_versions" "us-central1-c" {
  provider       = google-beta
  location       = var.gke_config["region"]
  version_prefix = var.gke_config["node_version"]
}
resource "google_container_cluster" "primary" {
  name                     = var.gke_config["cluster_name"]
  location                 = var.gke_config["region"]
  remove_default_node_pool = false
  node_version             = data.google_container_engine_versions.us-central1-c.latest_node_version
  initial_node_count       = var.gke_config["node_count"]
  node_locations = [
    "${var.gke_config["region"]}-a",
    "${var.gke_config["region"]}-b",
    "${var.gke_config["region"]}-c",
    "${var.gke_config["region"]}-f"
  ]
  cluster_autoscaling {
    enabled = true
    resource_limits {
      resource_type = "cpu"
      minimum       = 1
      maximum       = 48
    }
    resource_limits {
      resource_type = "memory"
      minimum       = 4
      maximum       = 96
    }
  }
  master_auth {
    client_certificate_config {
      issue_client_certificate = false
    }
  }
}
variable "gke_config" {
  type = map(any)
  default = {
    region         = "us-central1"
    zone           = "us-central1-c"
    cluster_name   = "my-gke-cluster"
    machine_type   = "e2-medium"
    node_count     = 1
    node_pool_name = "my-node-pool"
    node_version   = "1.21.6"
    preemptible    = true
  }
}
resource "null_resource" "set-kubeconfig" {
  depends_on = [
    google_container_cluster.primary
  ]
  triggers = {
    always_run = "${timestamp()}"
  }
  provisioner "local-exec" {
    command = "gcloud container clusters get-credentials ${var.gke_config["cluster_name"]} --region ${var.gke_config["region"]}"
  }
}

main.tf

module "gke" {
  source = "./module/"
gke_config = {
    region         = "us-central1"
    zone           = "us-central1-c"
    cluster_name   = "project-cluster"
    machine_type   = "e2-medium"
    node_count     = 1
    node_pool_name = "my-node-pool"
    preemptible    = true
    node_version   = "1.23.5-gke.1500" # finds build version automatically based on region. We can change it to 1.21   . In this case it will automatically find minor version
  }
}
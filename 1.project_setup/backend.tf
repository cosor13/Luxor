terraform {
  backend "gcs" {
    bucket = "luxor"
    prefix = "1.project_setup"
  }
}

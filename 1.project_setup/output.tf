output"project_id"{
  value =google_project.luxor.id
}
output"project_name"{
  value =google_project.luxor.name
}
output"bucketname"{
  value =nonsensitive(google_storage_bucket.backend-luxor.name)
}

output"project_id"{
  value =google_project.testproject.id
}
output"project_name"{
  value =google_project.testproject.name
}
output"bucketname"{
  value =nonsensitive(google_storage_bucket.backend-bucket.name)
}


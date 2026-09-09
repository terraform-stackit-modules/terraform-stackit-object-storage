output "bucket_name" {
  description = "The name of the bucket created by the example."
  value       = module.object_storage.bucket_name
}

output "credentials_group_ids" {
  description = "The credentials group IDs created by the example."
  value       = module.object_storage.credentials_group_ids
}

output "credential_access_keys" {
  description = "The S3 access key IDs created by the example."
  value       = module.object_storage.credential_access_keys
}

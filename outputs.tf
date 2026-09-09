output "bucket_name" {
  description = "The name of the created bucket (null when create_bucket is false)."
  value       = var.create_bucket ? stackit_objectstorage_bucket.this[0].name : null
}

output "bucket_url_path_style" {
  description = "The path-style URL of the bucket (null when create_bucket is false)."
  value       = var.create_bucket ? stackit_objectstorage_bucket.this[0].url_path_style : null
}

output "bucket_url_virtual_hosted_style" {
  description = "The virtual-hosted-style URL of the bucket (null when create_bucket is false)."
  value       = var.create_bucket ? stackit_objectstorage_bucket.this[0].url_virtual_hosted_style : null
}

output "credentials_group_ids" {
  description = "Map of credentials group key to credentials group ID."
  value       = { for k, g in stackit_objectstorage_credentials_group.this : k => g.credentials_group_id }
}

output "credential_access_keys" {
  description = "Map of credential key (`<group>/<name>`) to S3 access key ID."
  value       = { for k, c in stackit_objectstorage_credential.this : k => c.access_key }
}

output "credential_secret_access_keys" {
  description = "Map of credential key (`<group>/<name>`) to S3 secret access key. Sensitive."
  value       = { for k, c in stackit_objectstorage_credential.this : k => c.secret_access_key }
  sensitive   = true
}

output "compliance_lock_max_retention_days" {
  description = "Maximum retention period in days allowed by the project compliance lock (null when not created by this module)."
  value       = var.create_compliance_lock ? stackit_objectstorage_compliance_lock.this[0].max_retention_days : null
}

output "default_retention_id" {
  description = "The ID of the bucket default-retention policy (null when not set)."
  value       = var.create_bucket && var.default_retention != null ? stackit_objectstorage_default_retention.this[0].id : null
}

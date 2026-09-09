resource "stackit_objectstorage_compliance_lock" "this" {
  count = var.create_compliance_lock ? 1 : 0

  project_id = var.project_id
  region     = var.region
}

resource "stackit_objectstorage_bucket" "this" {
  count = var.create_bucket ? 1 : 0

  project_id  = var.project_id
  region      = var.region
  name        = var.name
  object_lock = var.object_lock

  # A bucket with object_lock = true requires an active project-level compliance
  # lock to exist first.
  depends_on = [stackit_objectstorage_compliance_lock.this]
}

resource "stackit_objectstorage_default_retention" "this" {
  count = var.create_bucket && var.default_retention != null ? 1 : 0

  project_id  = var.project_id
  region      = var.region
  bucket_name = stackit_objectstorage_bucket.this[0].name
  days        = var.default_retention.days
  mode        = var.default_retention.mode
}

resource "stackit_objectstorage_credentials_group" "this" {
  for_each = var.credentials_groups

  project_id = var.project_id
  region     = var.region
  name       = each.value.name
}

resource "stackit_objectstorage_credential" "this" {
  for_each = {
    for c in local.credentials_flat : c.key => c
  }

  project_id           = var.project_id
  region               = var.region
  credentials_group_id = stackit_objectstorage_credentials_group.this[each.value.group_key].credentials_group_id
  expiration_timestamp = each.value.expiration_timestamp
}

locals {
  # Flatten: for each credentials group, expand its `credentials` list into
  # individual credential objects keyed as "<group_key>/<credential_name>".
  credentials_flat = flatten([
    for group_key, group in var.credentials_groups : [
      for cred in group.credentials : {
        key                  = "${group_key}/${cred.name}"
        group_key            = group_key
        expiration_timestamp = cred.expiration_timestamp
      }
    ]
  ])
}

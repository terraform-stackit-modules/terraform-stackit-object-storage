# ─── Bucket ───────────────────────────────────────────────────────────────────

variable "project_id" {
  description = "STACKIT project ID in which the bucket and credentials are created."
  type        = string
}

variable "create_bucket" {
  description = "Whether to create the Object Storage bucket. Set to false to manage only credentials groups/credentials against an existing bucket."
  type        = bool
  default     = true
}

variable "name" {
  description = "The bucket name. Must be DNS-conform."
  type        = string
}

variable "region" {
  description = "The resource region. If not defined, the provider region is used."
  type        = string
  default     = null
}

variable "object_lock" {
  description = "Enable Object Lock on the bucket. Can only be set at creation time and requires an active project-level compliance lock."
  type        = bool
  default     = null
}

# ─── Compliance lock (project-scoped) ─────────────────────────────────────────

variable "create_compliance_lock" {
  description = "Whether to create the project-level Object Storage compliance lock. Only ONE compliance lock may exist per project. Required (existing or created here) before a bucket can enable object_lock."
  type        = bool
  default     = false
}

# ─── Default retention ────────────────────────────────────────────────────────

variable "default_retention" {
  description = <<-EOT
    Optional default retention policy applied to the created bucket. Requires the bucket to have
    `object_lock = true` (and thus a project-level compliance lock).
      - `days` : retention period in days.
      - `mode` : retention mode, `GOVERNANCE` or `COMPLIANCE`.
  EOT
  type = object({
    days = number
    mode = string
  })
  default = null

  validation {
    condition     = var.default_retention == null || contains(["GOVERNANCE", "COMPLIANCE"], try(var.default_retention.mode, ""))
    error_message = "default_retention.mode must be either \"GOVERNANCE\" or \"COMPLIANCE\"."
  }
}

# ─── Credentials groups & credentials ─────────────────────────────────────────

variable "credentials_groups" {
  description = <<-EOT
    Map of Object Storage credentials groups to create, keyed by a stable identifier.
    Each group:
      - `name`        : display name of the credentials group.
      - `credentials` : list of S3 credentials to create in the group. Each credential:
          - `name`                 : stable name used to build the `for_each` key (`<group_key>/<name>`).
          - `expiration_timestamp` : RFC3339 UTC timestamp (e.g. "2027-01-02T03:04:05Z"). Omit for a credential that never expires.

    Note: the generated secret_access_key values are exposed via the `credential_secret_access_keys` output, which is marked sensitive.
  EOT
  type = map(object({
    name = string
    credentials = optional(list(object({
      name                 = string
      expiration_timestamp = optional(string)
    })), [])
  }))
  default = {}
}

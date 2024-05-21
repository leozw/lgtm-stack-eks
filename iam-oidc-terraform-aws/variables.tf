variable "create_lifecycle" {
  description = "Create lifecycle"
  type        = bool
  default     = false
}

variable "lifecycle_rules" {
  description = "Lifecycle rules for S3 bucket"
  type        = map(any)
  default     = {}
}

variable "force_destroy" {
  description = "Boolean that indicates all objects (including any locked objects) should be deleted from the bucket when the bucket is destroyed so that the bucket can be destroyed without error"
  type        = bool
  default     = false
}

variable "environment" {
  description = "Env tags"
  type        = string
  default     = ""
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

variable "rule_id" {
  description = "Unique identifier for the rule. The value cannot be longer than 255 characters"
  type        = string
  default     = ""
}

variable "expiration" {
  description = "Configuration block that specifies the expiration for the lifecycle of the object in the form of date, days and, whether the object has a delete marker"
  type        = map(any)
  default     = {}
}

variable "filter" {
  description = "Configuration block used to identify objects that a Lifecycle Rule applies to."
  type        = map(any)
  default     = {}
}

variable "status_lifecycle" {
  description = "Whether the rule is currently being applied. Valid values: Enabled or Disabled"
  type        = string
  default     = "Disabled"
}

variable "abort_incomplete_multipart_upload" {
  description = "Number of days after which Amazon S3 aborts an incomplete multipart upload"
  type        = map(any)
  default     = {}
}

variable "noncurrent_version_expiration" {
  description = "Number of days an object is noncurrent before Amazon S3 can perform the associated action. Must be a positive integer."
  type        = map(any)
  default     = {}
}

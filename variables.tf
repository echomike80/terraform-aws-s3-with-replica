variable "create_replica_bucket" {
  description = "Create S3 bucket for replication"
  type        = bool
  default     = true
}

variable "use_existing_replica_bucket" {
  description = "Name of an existing S3 bucket for replication, if create_replica_bucket is false"
  type        = string
  default     = "s3-bucket-that-already-exists"
}

variable "name" {
  description = "Name to be used on all resources"
  type        = string
}

variable "random_suffix" {
  description = "Name to be used on S3 buckets as suffix"
  type        = string
}

variable "region_origin" {
  description = "Name of region from origin S3 bucket"
  type        = string
  default     = "eu-central-1"
}

variable "region_replica" {
  description = "Name of region from replica S3 bucket"
  type        = string
  default     = "eu-central-1"
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}
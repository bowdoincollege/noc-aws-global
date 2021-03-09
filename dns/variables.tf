variable "delegation_set_id" {
  description = "Identifier for pre-existing delegation set"
  type        = string
}

variable "zone" {
  description = "DNS zone to create/manage"
  type        = string
  validation {
    condition     = can(regex("^[.0-9a-z-]+$", var.zone))
    error_message = "Zone must be a valid DNS name."
  }
}

variable "hostmaster" {
  description = "Email address of hostmaster"
  type        = string
  validation {
    condition     = can(regex("^[0-9a-z.-]+@[0-9a-z.-]+[0-9a-z]$", var.hostmaster))
    error_message = "Email address must be in user@example.com format."
  }
}

variable "tags" {
  description = "Common tags for created resources"
  type        = map(any)
  default     = {}
}

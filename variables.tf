variable "authoritative_zones" {
  description = "List of DNS zones to create/manage"
  type        = list(string)
  validation {
    condition = alltrue([
      for zone in var.authoritative_zones : can(regex("^[.0-9a-z-]+$", zone))
    ])
    error_message = "Zone must be a valid DNS name."
  }
}

variable "delegation_set_id" {
  description = "Identifier for pre-existing delegation set"
  type        = string
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

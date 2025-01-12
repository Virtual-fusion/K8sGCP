variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The GCP region to deploy resources"
  type        = string
  default     = "europe-west1" # Set a default if needed
}

variable "gcp-project-id" {
  description = "The Google Cloud project ID for the provider configuration"
  type        = string
}

variable "db-password" {
  description = "The password for the MySQL database user"
  type        = string
  sensitive   = true
}

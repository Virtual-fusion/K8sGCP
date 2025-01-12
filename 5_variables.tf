variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The GCP region to deploy resources"
  type        = string
  default     = "europe-west1" # Default value
}

variable "db_password_base64" {
  description = "The Base64-encoded password for the MySQL database user"
  type        = string
  sensitive   = true # Ensures it doesn't show in logs
}

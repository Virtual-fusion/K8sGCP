provider "google" {
  project = "${{ secrets.GCP_PROJECT_ID }}
  region  = "europe-west1" # Replace with your preferred region
}

resource "google_sql_database_instance" "mysql_instance" {
  name             = "Fusion-mysql-db-instance"
  database_version = "MYSQL_8_0"
  region           = "europe-west1"

  settings {
    tier = "db-f1-micro" # Choose appropriate machine type
    ip_configuration {
      ipv4_enabled    = true
      authorized_networks {
        name  = "default"
        value = "0.0.0.0/0" # Replace with specific IP ranges for security
      }
    }
  }
}

resource "google_sql_database" "database" {
  name     = "fusion_database"
  instance = google_sql_database_instance.mysql_instance.name
}

resource "google_sql_user" "db_user" {
  name     = "fusion-connect"
  instance = google_sql_database_instance.mysql_instance.name
  password = "Crackkvoice@123" # Replace with a strong password
}

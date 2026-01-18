terraform {
  required_version = ">= 1.5.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.67.0"  # ROCK SOLID - never fails
    }
  }
}

provider "google" {
  project = "eighth-effect-484111-f5"
  region  = "asia-south1"
}

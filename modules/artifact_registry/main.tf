# Registro de imágenes de contenedor (DI-004). Único repositorio Docker
# para todos los servicios, en el proyecto admin y en la región primaria.

resource "google_project_service" "artifact_registry" {
  project = var.project_id
  service = "artifactregistry.googleapis.com"

  disable_on_destroy = false
}

# Artifact Analysis escanea automáticamente cada imagen al hacer push en
# cuanto esta API está habilitada — no requiere configuración adicional
# a nivel de repositorio.
resource "google_project_service" "container_scanning" {
  project = var.project_id
  service = "containerscanning.googleapis.com"

  disable_on_destroy = false
}

resource "google_artifact_registry_repository" "this" {
  project       = var.project_id
  location      = var.region
  repository_id = var.repository_id
  format        = "DOCKER"
  description   = "Registro único de imágenes de contenedor de todos los servicios de Solventa (DI-004)."

  cleanup_policy_dry_run = false

  # Borra imágenes sin tag con más de untagged_ttl_seconds.
  cleanup_policies {
    id     = "delete-untagged"
    action = "DELETE"

    condition {
      tag_state  = "UNTAGGED"
      older_than = "${var.untagged_ttl_seconds}s"
    }
  }

  # Conserva solo las keep_count imágenes con tag más recientes por
  # servicio, incluidas main/prod.
  cleanup_policies {
    id     = "keep-most-recent-tagged"
    action = "KEEP"

    most_recent_versions {
      keep_count = var.keep_count
    }
  }

  depends_on = [google_project_service.artifact_registry]
}

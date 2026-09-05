output "repository_id" {
  description = "Nombre del repositorio de Artifact Registry."
  value       = google_artifact_registry_repository.this.repository_id
}

output "location" {
  description = "Región del repositorio de Artifact Registry."
  value       = google_artifact_registry_repository.this.location
}

output "repository_path" {
  description = "Ruta completa del repositorio (host + proyecto + nombre), para construir tags de imagen."
  value       = "${google_artifact_registry_repository.this.location}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.this.repository_id}"
}

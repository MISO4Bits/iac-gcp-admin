output "project_id" {
  description = "Proyecto de GCP del ambiente admin."
  value       = var.project_id
}

output "region" {
  description = "Región primaria de los recursos de admin."
  value       = var.region
}

output "artifact_registry_repository" {
  description = "Ruta del repositorio de Artifact Registry (DI-004)."
  value       = "${var.region}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.solventa.repository_id}"
}

output "workload_identity_provider" {
  description = "Nombre completo del proveedor de Workload Identity Federation, para configurar en los workflows de GitHub Actions (google-github-actions/auth)."
  value       = google_iam_workload_identity_pool_provider.github_actions.name
}

output "ci_image_publisher_email" {
  description = "Correo de la cuenta de servicio usada por los pipelines de CI para publicar imágenes."
  value       = google_service_account.ci_image_publisher.email
}

output "provider_name" {
  description = "Nombre completo del proveedor de Workload Identity Federation, para configurar en los workflows de GitHub Actions (google-github-actions/auth)."
  value       = google_iam_workload_identity_pool_provider.github_actions.name
}

output "ci_image_publisher_email" {
  description = "Correo de la cuenta de servicio usada por los pipelines de CI para publicar imágenes."
  value       = google_service_account.ci_image_publisher.email
}

output "ci_image_publisher_name" {
  description = "Nombre completo del recurso de la cuenta de servicio (para vincularla a otros roles fuera de este módulo)."
  value       = google_service_account.ci_image_publisher.name
}

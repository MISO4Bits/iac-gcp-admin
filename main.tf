# Raíz de composición: solo instancia módulos y conecta sus salidas. La
# lógica de cada recurso vive dentro de modules/.

module "artifact_registry" {
  source = "./modules/artifact_registry"

  project_id = var.project_id
  region     = var.region
}

module "workload_identity" {
  source = "./modules/workload_identity"

  project_id            = var.project_id
  github_org            = var.github_org
  image_publisher_repos = var.image_publisher_repos
}

# Único permiso de la cuenta de publicación de imágenes: escribir en el
# repositorio de Artifact Registry (DI-004). Vive aquí, no en un módulo,
# porque conecta recursos de dos módulos distintos.
resource "google_artifact_registry_repository_iam_member" "ci_image_publisher_writer" {
  project    = var.project_id
  location   = module.artifact_registry.location
  repository = module.artifact_registry.repository_id
  role       = "roles/artifactregistry.writer"
  member     = "serviceAccount:${module.workload_identity.ci_image_publisher_email}"
}

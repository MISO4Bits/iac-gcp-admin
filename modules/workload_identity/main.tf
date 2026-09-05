# Federación de identidades de carga de trabajo (Workload Identity
# Federation, WIF) para que los pipelines de GitHub Actions se autentiquen
# contra Google Cloud Platform (GCP) sin llaves estáticas (DI-004).

resource "google_project_service" "iam_credentials" {
  project = var.project_id
  service = "iamcredentials.googleapis.com"

  disable_on_destroy = false
}

resource "google_iam_workload_identity_pool" "github_actions" {
  project                   = var.project_id
  workload_identity_pool_id = "github-actions"
  display_name              = "GitHub Actions"
  description               = "Pool de identidades para los pipelines de GitHub Actions de ${var.github_org} (DI-004)."

  depends_on = [google_project_service.iam_credentials]
}

resource "google_iam_workload_identity_pool_provider" "github_actions" {
  project                            = var.project_id
  workload_identity_pool_id          = google_iam_workload_identity_pool.github_actions.workload_identity_pool_id
  workload_identity_pool_provider_id = "github"
  display_name                       = "GitHub"

  attribute_mapping = {
    "google.subject"             = "assertion.sub"
    "attribute.repository"       = "assertion.repository"
    "attribute.repository_owner" = "assertion.repository_owner"
    "attribute.ref"              = "assertion.ref"
  }

  # Solo se aceptan tokens emitidos para repositorios de la organización
  # del proyecto (DI-004).
  attribute_condition = "assertion.repository_owner == '${var.github_org}'"

  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }
}

# Cuenta de servicio dedicada a publicar imágenes de contenedor. Sin
# llave estática: los pipelines obtienen un token de vida corta vía WIF.
resource "google_service_account" "ci_image_publisher" {
  project      = var.project_id
  account_id   = "ci-image-publisher"
  display_name = "CI - Publicador de imágenes de contenedor"
  description  = "Usada por los pipelines de CI para publicar imágenes en Artifact Registry (DI-004)."
}

# Vinculación acotada por repositorio: cada repo de servicio que publica
# imágenes se agrega explícitamente a var.image_publisher_repos (DI-004).
resource "google_service_account_iam_member" "ci_image_publisher_workload_identity" {
  for_each = toset(var.image_publisher_repos)

  service_account_id = google_service_account.ci_image_publisher.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.github_actions.name}/attribute.repository/${var.github_org}/${each.value}"
}

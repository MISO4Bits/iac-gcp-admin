variable "project_id" {
  description = "ID del proyecto de Google Cloud Platform (GCP) del ambiente admin (DI-003)."
  type        = string
  default     = "solventa-admin"
}

variable "region" {
  description = "Región primaria de GCP para los recursos de admin (DI-002: São Paulo)."
  type        = string
  default     = "southamerica-east1"
}

variable "github_org" {
  description = "Organización de GitHub que aloja los repositorios del proyecto."
  type        = string
  default     = "MISO4Bits"
}

variable "image_publisher_repos" {
  description = "Repositorios de GitHub autorizados a publicar imágenes en Artifact Registry vía Workload Identity Federation (DI-004)."
  type        = list(string)
  default = [
    "svc-core",
    "svc-cotizacion",
    "svc-perfilamiento",
    "svc-productos",
    "svc-distribucion",
    "bff-web",
    "bff-mobile",
    "api-partner",
  ]
}

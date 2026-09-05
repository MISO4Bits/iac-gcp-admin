variable "project_id" {
  description = "ID del proyecto de GCP donde se crea el pool de Workload Identity Federation."
  type        = string
}

variable "github_org" {
  description = "Organización de GitHub autorizada a autenticarse contra este pool."
  type        = string
}

variable "image_publisher_repos" {
  description = "Repositorios de GitHub autorizados a asumir la cuenta de servicio de publicación de imágenes, uno por uno (vinculación acotada por repositorio, DI-004)."
  type        = list(string)
  default     = []
}

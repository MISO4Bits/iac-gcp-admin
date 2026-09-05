variable "project_id" {
  description = "ID del proyecto de GCP donde se crea el repositorio."
  type        = string
}

variable "region" {
  description = "Región del repositorio de Artifact Registry."
  type        = string
}

variable "repository_id" {
  description = "Nombre del repositorio de Artifact Registry."
  type        = string
  default     = "solventa"
}

variable "keep_count" {
  description = "Número de imágenes con tag más recientes a conservar por servicio."
  type        = number
  default     = 2
}

variable "untagged_ttl_seconds" {
  description = "Segundos tras los cuales se borran las imágenes sin tag (por defecto, 7 días)."
  type        = number
  default     = 604800
}

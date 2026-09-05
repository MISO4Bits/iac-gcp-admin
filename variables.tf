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

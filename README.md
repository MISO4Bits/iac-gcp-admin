# iac-gcp-admin

Infraestructura como código (Terraform) del ambiente **admin** de Solventa: registro de imágenes de contenedor, federación de identidades para los pipelines, gobierno de repositorios de GitHub, análisis de calidad de código y observabilidad. Ver [DI-003](https://miso4bits.atlassian.net/wiki/spaces/4BITS/pages/44630018) para el porqué de la separación de ambientes.

Se aplica **primero**, antes que `iac-gcp-dev` e `iac-gcp-prod` — contiene la federación de identidades (Workload Identity Federation, WIF) que los demás pipelines usan para autenticarse contra Google Cloud Platform (GCP).

## Prerrequisitos

- Proyecto de GCP `solventa-admin` ya creado, con facturación activa.
- Bucket de estado `gs://4bits-tfstate-admin` ya creado a mano (ver Confluence 4BITS → "Crear los buckets de estado de Terraform"). Terraform no puede crear el bucket donde guarda su propio estado.
- [Terraform](https://developer.hashicorp.com/terraform) >= 1.7.
- `gcloud auth application-default login` para autenticación local (los pipelines usan Workload Identity Federation, no llaves estáticas).

## Uso

```shell
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform plan
terraform apply
```

`terraform.tfvars` no se versiona (ver `.gitignore`) — ajustar ahí cualquier valor distinto al de los defaults en `variables.tf`.

## Estructura

```
iac-gcp-admin/
├── modules/                 # una carpeta por pieza reusable, con su propia interfaz (variables/outputs)
│   ├── artifact_registry/
│   └── workload_identity/
├── main.tf                  # raíz: solo instancia módulos y conecta sus salidas
├── backend.tf
├── providers.tf
├── variables.tf
├── outputs.tf
└── versions.tf
```

Este repo representa **un solo ambiente** (`admin`, DI-003) — no hay carpeta `environments/`, porque no hace falta: cada ambiente ya es su propio repositorio (`iac-gcp-admin`, `iac-gcp-dev`, `iac-gcp-prod`), cada uno con su propio estado. `modules/` no se comparte entre esos repos (duplicación aceptada a propósito en DI-003, a cambio de independencia total).

Convención al agregar un módulo nuevo: cada uno declara sus propias `variables.tf`/`outputs.tf` y no conoce a los demás; cualquier recurso que conecte dos módulos (por ejemplo, un permiso de IAM entre una cuenta de servicio de un módulo y un recurso de otro) vive en el `main.tf` de la raíz, no dentro de ningún módulo.


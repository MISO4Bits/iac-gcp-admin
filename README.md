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


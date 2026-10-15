<div align="center">

<br/>

```
██╗     ██╗███╗   ██╗ ██████╗ ██╗   ██╗██╗███████╗████████╗ █████╗
██║     ██║████╗  ██║██╔════╝ ██║   ██║██║██╔════╝╚══██╔══╝██╔══██╗
██║     ██║██╔██╗ ██║██║  ███╗██║   ██║██║███████╗   ██║   ███████║
██║     ██║██║╚██╗██║██║   ██║██║   ██║██║╚════██║   ██║   ██╔══██║
███████╗██║██║ ╚████║╚██████╔╝╚██████╔╝██║███████║   ██║   ██║  ██║
╚══════╝╚═╝╚═╝  ╚═══╝ ╚═════╝  ╚═════╝ ╚═╝╚══════╝   ╚═╝   ╚═╝  ╚═╝
```

**Master any language. Anytime, anywhere.**

📱 iOS / Swift client: [dannydjg16/Linguista](https://github.com/dannydjg16/Linguista)<br/>
🔗 .NET backend API: [dannydjg16/linguista-api](https://github.com/dannydjg16/linguista-api)

[![Terraform](https://img.shields.io/badge/Terraform-1.5+-7B42BC?style=flat-square&logo=terraform&logoColor=white)](https://www.terraform.io)
[![Azure](https://img.shields.io/badge/Azure-App_Service-0078D4?style=flat-square&logo=microsoftazure&logoColor=white)](https://azure.microsoft.com/products/app-service)
[![azurerm](https://img.shields.io/badge/azurerm-3.113-0078D4?style=flat-square)](https://registry.terraform.io/providers/hashicorp/azurerm/latest)
[![.NET](https://img.shields.io/badge/.NET-8.0-512BD4?style=flat-square&logo=dotnet&logoColor=white)](https://dotnet.microsoft.com)

<br/>

</div>

# linguista-tf

Terraform configuration for the Azure infrastructure behind **Linguista**, a language-learning app. It provisions the App Service that hosts the [.NET 8 backend API](https://github.com/dannydjg16/linguista-api), which the [iOS app](https://github.com/dannydjg16/Linguista) talks to.

## What it creates

| Resource | Name | Details |
|---|---|---|
| `azurerm_resource_group` | `linguista-resources` | Region: East US |
| `azurerm_service_plan` | `linguista-appserviceplan` | Linux, `B1` SKU |
| `azurerm_linux_web_app` | `linguista-appservice` | .NET 8 runtime, starts `linguista-api.dll`, health check on `/healthz` |

This repo only creates the infrastructure. The API code is built and deployed to `linguista-appservice` by the GitHub Actions workflow in [linguista-api](https://github.com/dannydjg16/linguista-api).

## Project structure

```
linguista-tf/
├── main.tf               # Provider, resource group, service plan, web app
├── variables.tf          # Input variables
└── .terraform.lock.hcl   # Pinned provider versions (azurerm 3.113.0)
```

## Variables

| Name | Default | Description |
|---|---|---|
| `dotnet8` | `"8.0"` | .NET version for the web app's application stack |
| `healthcheckEndpoint` | `"/healthz"` | Path App Service calls for health checks |

## Getting started

### Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/install) 1.5 or later
- [Azure CLI](https://learn.microsoft.com/cli/azure/install-azure-cli)
- An Azure subscription with permission to create resource groups and App Services

### Authenticate

The `azurerm` provider uses your Azure CLI login, so no credentials are stored in this repo:

```bash
az login
az account set --subscription "<subscription-id>"
```

### Deploy

```bash
terraform init
terraform plan
terraform apply
```

To tear everything down:

```bash
terraform destroy
```

## State

State is stored locally in `terraform.tfstate`, which is git-ignored. It can contain resource IDs and other sensitive values, so never commit it. If more than one person or a CI pipeline will run Terraform, move the state to a remote backend such as an Azure Storage account.

## Secrets

Don't put secrets such as the `OpenAiKey` the API needs in `main.tf`. Set them as App Service application settings in the Azure portal or with the Azure CLI, or reference them from Azure Key Vault.

The web app has `lifecycle { ignore_changes = [app_settings] }`, so `terraform apply` won't overwrite or remove settings added outside Terraform.

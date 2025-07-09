# About

This plays with the [terraform remote state](https://developer.hashicorp.com/terraform/language/state/remote) using the [azurerm backend](https://developer.hashicorp.com/terraform/language/backend/azurerm) backed by the [azurite storage emulator](https://github.com/Azure/Azurite).

**NB** Currently this requires a custom build of terraform which adds support for using a custom storage endpoint (read from the `AZURE_STORAGE_SERVICE_ENDPOINT` environment variable).

**NB** Currently this requires a custom build of Azurite which disables the access token validation.

# Usage

To support setting the azurerm remote state blob endpoint, install Go, then build the custom terraform flavor:

```bash
git clone -b rgl-azurite https://github.com/rgl/terraform.git
pushd terraform
go build
install terraform ../init
popd
```

Install Docker and Docker Compose.

Create the environment:

```bash
docker compose up --build --detach
```

Open a shell inside the `init` container:

```bash
docker compose exec init bash
```

Inspect the remote storage state:

```bash
# NB this should show the terraform container.
az storage container list | jq -r '.[] | .name'
# NB this should not return any blob.
az storage blob list -c terraform | jq -r '.[] | .name'
```

Init the terraform configuration:

```bash
cd /host
export TF_LOG=DEBUG
terraform init
```

Inspect the state blob before applying the terraform configuration:

```bash
# NB the playground.terraform.tfstate blob should now be returned.
az storage blob list -c terraform | jq -r '.[] | .name'
az storage blob show -c terraform -n playground.terraform.tfstate
az storage blob download -c terraform -n playground.terraform.tfstate | jq
```

Apply the terraform configuration:

```bash
terraform apply
```

Inspect the state blob after applying the terraform configuration:

```bash
az storage blob show -c terraform -n playground.terraform.tfstate | jq
az storage blob download -c terraform -n playground.terraform.tfstate | jq
```

Interact with Gitea using `tea`:

```bash
tea login add
tea admin users list
tea org list
tea repos list
```

Destroy the terraform configuration:

```bash
terraform destroy
```

Exit the container:

```bash
exit
```

Destroy the environment:

```bash
docker compose down --remove-orphans --volumes --timeout=0
```

# see https://github.com/hashicorp/terraform
terraform {
  required_version = "1.12.2"
  backend "azurerm" {
    storage_account_name = ""
    container_name       = "terraform"
    key                  = "playground.terraform.tfstate"
  }
  required_providers {
    # see https://registry.terraform.io/providers/go-gitea/gitea
    # see https://gitea.com/gitea/terraform-provider-gitea
    # see https://github.com/go-gitea/terraform-provider-gitea
    gitea = {
      source  = "go-gitea/gitea"
      version = "0.7.0"
    }
  }
}

# see https://registry.terraform.io/providers/go-gitea/gitea/0.7.0/docs
provider "gitea" {
}

# see https://registry.terraform.io/providers/go-gitea/gitea/0.7.0/docs/resources/user
resource "gitea_user" "jane" {
  username             = "jane"
  login_name           = "jane"
  password             = "password"
  email                = "jane@example.com"
  must_change_password = false
}

# see https://registry.terraform.io/providers/go-gitea/gitea/0.7.0/docs/resources/user
resource "gitea_user" "joe" {
  username             = "joe"
  login_name           = "joe"
  password             = "password"
  email                = "joe@example.com"
  must_change_password = false
}

# see https://registry.terraform.io/providers/go-gitea/gitea/0.7.0/docs/resources/org
resource "gitea_org" "example" {
  name = "example"
}

# see https://registry.terraform.io/providers/go-gitea/gitea/0.7.0/docs/resources/team
resource "gitea_team" "developers" {
  organisation = gitea_org.example.name
  name         = "Developers"
  description  = "Developer"
  permission   = "write"
  repositories = [
    gitea_repository.test.name,
  ]
}

# see https://registry.terraform.io/providers/go-gitea/gitea/0.7.0/docs/resources/team_members
resource "gitea_team_members" "developers_members" {
  team_id = gitea_team.developers.id
  members = [
    gitea_user.jane.username,
  ]
}

# see https://registry.terraform.io/providers/go-gitea/gitea/0.7.0/docs/resources/repository
resource "gitea_repository" "test" {
  username    = gitea_org.example.name
  name        = "test"
  description = "Test repository."
  private     = false
  auto_init   = false
}

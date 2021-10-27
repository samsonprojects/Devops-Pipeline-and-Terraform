# Configure the Azure Provider
# https://www.terraform.io/docs/providers/azurerm/index.html
provider "azurerm" {
    version = "2.5.0"
    features{}
}

#configuring terraform to use blob storage in azure to store our state file
terraform {
    backend "azurerm" {
        resource_group_name = "tf_rg_blobstore"
        storage_account_name = "tfstorageaccountskab"
        container_name = "tfstate"
        key = "terraform.tfstate"
    }
}

resource "azurerm_resource_group" "tf_test" {
    name = "tfmainrg"
    location = "UK West"
}

resource "azurerm_container_group" "tfcg_test" {
    name                = "weatherapi"
    location            = azurerm_resource_group.tf_test.location
    resource_group_name  = azurerm_resource_group.tf_test.name

    ip_address_type     = "public"
    dns_name_label      = "samsonantwiwebapi"
    os_type             = "Linux" 

    container {
        name            = "weatherapi"
        image           = "samsonantwi123/weatherapi"
        cpu             =  "1"
        memory          =  "1"

        ports {
            port        = 80
            protocol    = "TCP"
        }
    }
}



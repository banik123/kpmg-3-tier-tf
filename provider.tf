terraform {
  required_version = ">=0.12"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.0"
    }
  }
}
provider "azurerm" {
    subscription_id = "3120408b-74d6-4408-a4fb-5b5a7d977000"
 
}
locals {
  # classification: prod -> p, others -> np
  classification = var.environment == "prod" ? "p" : "np"

  # map long region names to short codes used in names
  region_map = {
    uksouth      = "uks"
    ukwest       = "ukw"
    northeurope  = "neu"
    westeurope   = "weu"
    eastus       = "eus"
    eastus2      = "eu2"
    centralus    = "cus"
    westus3      = "wu3"
    centralindia = "cin"
    southindia   = "sin"
    westindia    = "win"
  }

  region_code = lookup(local.region_map, var.location, var.location)

  # base naming pattern: <service>-<classification>-<region>-<environment>
  name = {
    vnet    = format("vnet-%s-%s-%s", local.classification, local.region_code, var.environment)
    subnet  = format("snet-%s-%s-%s", local.classification, local.region_code, var.environment)
    nsg     = format("nsg-%s-%s-%s", local.classification, local.region_code, var.environment)
    vm      = format("vm-%s-%s-%s", local.classification, local.region_code, var.environment)
    nic     = format("nic-%s-%s-%s", local.classification, local.region_code, var.environment)
    pip     = format("pip-%s-%s-%s", local.classification, local.region_code, var.environment)
    storage = format("st-%s-%s-%s", local.classification, local.region_code, var.environment)
  }

  # storage account name must be 3-24 chars, lowercase alphanumeric only
  storage_name = substr(lower(replace(local.name.storage, "-", "")), 0, 24)
}

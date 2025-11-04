resource "azurerm_public_ip" "pip" {
  count               = var.create_public_ip ? 1 : 0
  name                = var.pip_name
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

resource "azurerm_network_interface" "nic" {
  name                = var.nic_name
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "ipcfg"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = var.create_public_ip ? azurerm_public_ip.pip[0].id : null
  }
  tags = var.tags
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                  = var.name
  location              = var.location
  resource_group_name   = var.resource_group_name
  size                  = var.size
  admin_username        = var.admin_username
  network_interface_ids = [azurerm_network_interface.nic.id]

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.ssh_public_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  dynamic "source_image_reference" {
    for_each = var.image == null ? [1] : []
    content {
      publisher = "Canonical"
      offer     = "0001-com-ubuntu-server-jammy"
      sku       = "22_04-lts"
      version   = "latest"
    }
  }

  dynamic "source_image_reference" {
    for_each = var.image == null ? [] : [var.image]
    content {
      publisher = source_image_reference.value.publisher
      offer     = source_image_reference.value.offer
      sku       = source_image_reference.value.sku
      version   = source_image_reference.value.version
    }
  }

  identity {
    type = var.identity_enabled ? "SystemAssigned" : "None"
  }

  tags = var.tags
}

resource "azurerm_managed_disk" "data" {
  for_each             = { for i, size in var.data_disks_gb : i => size }
  name                 = "${var.name}-data-${each.key}"
  location             = var.location
  resource_group_name  = var.resource_group_name
  storage_account_type = "Premium_LRS"
  create_option        = "Empty"
  disk_size_gb         = each.value
  tags                 = var.tags
}

resource "azurerm_virtual_machine_data_disk_attachment" "attach" {
  for_each           = azurerm_managed_disk.data
  managed_disk_id    = each.value.id
  virtual_machine_id = azurerm_linux_virtual_machine.vm.id
  lun                = each.key
  caching            = "ReadOnly"
}

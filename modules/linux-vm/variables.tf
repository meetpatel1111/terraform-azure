variable "name" {
  type        = string
  description = "Name of the Linux Virtual Machine."
}

variable "location" {
  type        = string
  description = "Azure region where the VM will be created."
}

variable "resource_group_name" {
  type        = string
  description = "Resource Group name that will contain the VM and networking resources."
}

variable "subnet_id" {
  type        = string
  description = "ID of the Subnet where the VM NIC will be placed."
}

variable "size" {
  type        = string
  description = "Size (SKU) of the VM (e.g. Standard_B2s)."
}

variable "admin_username" {
  type        = string
  description = "Admin username for the VM."
}

variable "ssh_public_key" {
  type        = string
  description = "SSH public key used to access the VM."
}

variable "create_public_ip" {
  type        = bool
  description = "Whether to create and associate a Public IP with the VM."
}

variable "data_disks_gb" {
  type        = list(number)
  description = "List of data disk sizes in GB to attach to the VM."
  default     = []
}

variable "identity_enabled" {
  type        = bool
  description = "Whether to enable System Assigned Managed Identity on the VM."
  default     = true
}

variable "image" {
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
  description = "Marketplace image configuration. If null, defaults to Ubuntu 22.04 LTS."
  default     = null
}

variable "nic_name" {
  type        = string
  description = "Name of the Network Interface resource to create."
}

variable "pip_name" {
  type        = string
  description = "Name of the Public IP resource (only used if create_public_ip = true)."
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to all VM-related resources."
  default     = {}
}

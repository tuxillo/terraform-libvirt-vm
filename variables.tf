variable "os_img_url" {
  description = "URL to the OS image"
  default     = "https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.img"
}

variable "base_volume_name" {
  description = "Name of base OS image"
  default     = null
}

variable "base_pool_name" {
  description = "Name of base OS image"
  default     = null
}

variable "additional_disk_ids" {
  description = "List of volume ids"
  default     = []
}


variable "autostart" {
  description = "Autostart the domain"
  default     = true
}

variable "vm_count" {
  description = "Number of VMs"
  default     = 1
}

variable "index_start" {
  description = "From where the indexig start"
  default     = 1
}

variable "vm_hostname_prefix" {
  description = "VM hostname prefix"
  default     = "vm"
}

variable "hostname" {
  description = "VM hostname or FQDN"
  type        = string
  default     = "server"
}

variable "memory" {
  description = "RAM in MB"
  type        = string
  default     = "1024"
}

variable "cpu_mode" {
  description = "CPU mode"
  default     = "host-passthrough"
}

variable "xml_override" {
  description = "With these variables you can: Enable hugepages; Set USB controllers; Attach USB devices"
  type        = any
  default = {

    hugepages = false,

    usb_controllers = [
      {
        model = "piix3-uhci"
      }
    ],

    usb_devices = [
      # {
      #   vendor = "0x0123",
      #   product = "0xabcd"
      # }
    ]
  }

}

variable "vcpu" {
  description = "Number of vCPUs"
  default     = 1
}

variable "pool" {
  description = "Storage pool name"
  default     = "default"
}

variable "system_volume" {
  description = "System Volume size (GB)"
  default     = 10
}

variable "share_filesystem" {
  type = object({
    source   = string
    target   = string
    readonly = bool
    mode     = string
  })
  default = {
    source   = null
    target   = null
    readonly = false
    mode     = null
  }
}

variable "dhcp" {
  description = "Use DHCP or Static IP settings"
  type        = bool
  default     = false
}

variable "bridge" {
  description = "Bridge interface"
  default     = "virbr0"
}

variable "mac_address" {
  description = "MAC address"
  type        = list
  default     = []
}


variable "ip_address" {
  description = "List of IP addresses"
  type        = list(string)
  default     = ["192.168.123.101"]
}

variable "ip_nameserver" {
  description = "IP addresses of a nameserver"
  default     = "192.168.123.1"
}

variable "ip_gateway" {
  description = "IP addresses of a gateway"
  default     = "192.168.123.1"
}

variable "ssh_admin" {
  description = "Admin user with ssh access"
  default     = "ssh-admin"
}

variable "ssh_keys" {
  description = "List of public ssh keys"
  type        = list(string)
  default     = []
}

variable "local_admin" {
  description = "Admin user without ssh access"
  default     = ""
}

variable "local_admin_passwd" {
  description = "Local admin user password"
  default     = "password_example"
}

variable "time_zone" {
  description = "Time Zone"
  default     = "UTC"
}

variable "ssh_private_key" {
  description = "Private key for SSH connection test"
  default     = null
}

variable "ssh_host_override" {
  description = "Host for SSH connection test"
  default     = null
}

variable "ssh_port_override" {
  description = "Port for SSH connection test"
  default     = 22
}

variable "ssh_bastion_connect" {
  description = "Use a bastion host to connect through"
  default     = {
    host    = ""
    port    = "22"
    user    = "root"
    passwd  = ""
    privkey = null
  }
}

variable "runcmd" {
  description = "Extra commands to be run with cloud init"
  type        = list(string)
  default = [
    "[ systemctl, daemon-reload ]",
    "[ systemctl, enable, qemu-guest-agent ]",
    "[ systemctl, start, qemu-guest-agent ]",
    "[ systemctl, restart, systemd-networkd ]"
  ]
}

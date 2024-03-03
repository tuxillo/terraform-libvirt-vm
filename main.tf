terraform {
  required_version = ">= 0.13"
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = ">=0.6.9"
    }
  }
}

resource "libvirt_domain" "virt-machine" {
  count  = var.vm_count
  name   = format("${var.vm_hostname_prefix}%02d", count.index + var.index_start)
  memory = var.memory
  cpu {
    mode = var.cpu_mode
  }
  vcpu       = var.vcpu
  autostart  = var.autostart
  qemu_agent = true

  cloudinit = element(libvirt_cloudinit_disk.commoninit.*.id, count.index)

  network_interface {
    bridge         = var.bridge
    wait_for_lease = true
    hostname       = format("${var.vm_hostname_prefix}%02d", count.index + var.index_start)
    mac            = length(var.mac_address) == var.vm_count ? element(var.mac_address, count.index) : null
  }

  xml {
    xslt = templatefile("${path.module}/xslt/template.tftpl", var.xml_override)
  }

  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }

  console {
    type        = "pty"
    target_type = "virtio"
    target_port = "1"
  }

  disk {
    volume_id = element(libvirt_volume.volume-qcow2.*.id, count.index)
  }

  dynamic "disk" {
    for_each = var.additional_disk_ids
    content {
      volume_id = disk.value
    }
  }

  dynamic "filesystem" {
    for_each = var.share_filesystem.source != null ? [var.share_filesystem.source] : []
    content {
      source     = var.share_filesystem.source
      target     = var.share_filesystem.target
      readonly   = var.share_filesystem.readonly
      accessmode = var.share_filesystem.mode
    }
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }

  provisioner "remote-exec" {
    inline = [
      "echo \"Virtual Machine \"$(hostname)\" is UP!\"",
      "date"
    ]
    connection {
      type          = "ssh"
      user          = var.ssh_admin
      host          = var.ssh_host_override != null ? var.ssh_host_override : self.network_interface.0.addresses.0
      port          = var.ssh_port_override
      private_key   = var.ssh_private_key != null ? file(var.ssh_private_key) : null
      bastion_host  = try(var.ssh_bastion_connect["host"], "") != "" ? var.ssh_bastion_connect["host"] : null
      bastion_user  = try(var.ssh_bastion_connect["user"], "") != "" ? var.ssh_bastion_connect["user"] : null
      bastion_port  = try(var.ssh_bastion_connect["port"], "") != "" ? var.ssh_bastion_connect["port"] : null
      bastion_private_key = try(var.ssh_bastion_connect["privkey"], null) != null ? var.ssh_bastion_connect["privkey"] : null
      timeout     = "2m"
    }
  }
}

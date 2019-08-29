terraform {
  required_version = ">= 0.12"
}

resource "openstack_compute_keypair_v2" "authkeys" {
  name       = "authkeys"
  public_key = file("${var.ssh_key_file}.pub")
}

// Security Groups 

resource "openstack_networking_secgroup_v2" "infra_sec_group" {
  name        = "infra_sec_group"
  description = "Security group for instances"
}

resource "openstack_networking_secgroup_rule_v2" "ssh_22" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.infra_sec_group.id
}

resource "openstack_networking_secgroup_rule_v2" "www_80" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 80
  port_range_max    = 80
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.infra_sec_group.id
}

resource "openstack_networking_secgroup_rule_v2" "icmp" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "icmp"
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.infra_sec_group.id
}

resource "openstack_networking_secgroup_rule_v2" "AllPortsforBeeGFStcp" {
  direction         = "ingress"
  ethertype         = "IPv4"
  port_range_min    = 8000
  port_range_max    = 8300
  protocol          = "tcp"
  remote_ip_prefix  = openstack_networking_subnet_v2.private_subnet.cidr
  security_group_id = openstack_networking_secgroup_v2.infra_sec_group.id
}

resource "openstack_networking_secgroup_rule_v2" "AllPortsforBeeGFSudp" {
  direction         = "ingress"
  ethertype         = "IPv4"
  port_range_min    = 8000
  port_range_max    = 8300
  protocol          = "udp"
  remote_ip_prefix  = openstack_networking_subnet_v2.private_subnet.cidr
  security_group_id = openstack_networking_secgroup_v2.infra_sec_group.id
}

//Networking Section 

resource "openstack_networking_network_v2" "private_net" {
  name           = "private_net"
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "private_subnet" {
  name            = "private_subnet"
  network_id      = openstack_networking_network_v2.private_net.id
  cidr            = "10.0.0.0/24"
  ip_version      = 4
  dns_nameservers = ["8.8.8.8", "8.8.4.4"]
}

resource "openstack_networking_router_v2" "private_router" {
  name                = "private_router"
  admin_state_up      = "true"
  external_network_id = data.openstack_networking_network_v2.private_net.id
}

resource "openstack_networking_router_interface_v2" "private_router_port" {
  router_id = openstack_networking_router_v2.private_router.id
  subnet_id = openstack_networking_subnet_v2.private_subnet.id
}

// Define Floating IP Pool 
resource "openstack_networking_floatingip_v2" "floating_ip" {
  pool = var.pool
}

resource "openstack_compute_floatingip_associate_v2" "headnode_floating_ip" {
  floating_ip = openstack_networking_floatingip_v2.floating_ip.address
  instance_id = openstack_compute_instance_v2.slurm_headnode.id
  provisioner "remote-exec" {
    inline = [
      "echo 'Beginning the provisioner exec....'",
      "sudo DEBIAN_FRONTEND=noninteractive apt-get -y update",
      "sudo DEBIAN_FRONTEND=noninteractive apt-get -y update",
      "sudo DEBIAN_FRONTEND=noninteractive apt-get -y install python3 python3-pip wget unzip",
      "sudo ln -s /usr/bin/python3 /usr/bin/python ",
      "sudo pip3 -q install ansible",
    ]
    connection {
      host        = openstack_networking_floatingip_v2.floating_ip.address
      user        = var.ssh_user_name
      private_key = file(var.ssh_key_file)
    }
  }
}

// Compute Instances 
// Slurm Headnode 
resource "openstack_compute_instance_v2" "slurm_headnode" {
  name            = "slurm-headnode"
  image_id        = data.openstack_images_image_v2.Ubuntu18.id
  flavor_name     = var.flavor
  key_pair        = openstack_compute_keypair_v2.authkeys.name
  security_groups = [openstack_networking_secgroup_v2.infra_sec_group.name]

  block_device {
    uuid                  = openstack_blockstorage_volume_v3.slurm_boot.id
    source_type           = "volume"
    boot_index            = 0
    destination_type      = "volume"
    delete_on_termination = false
  }

  network {
    uuid = openstack_networking_network_v2.private_net.id
  }
}

// Slurm Worker Nodes 
resource "openstack_compute_instance_v2" "slurm_workers" {
  name            = "slurm-wrk-${count.index + 1}"
  count           = var.worker_instance_count
  image_id        = data.openstack_images_image_v2.Ubuntu18.id
  flavor_name     = var.flavor
  key_pair        = openstack_compute_keypair_v2.authkeys.name
  security_groups = [openstack_networking_secgroup_v2.infra_sec_group.name]

  network {
    uuid = openstack_networking_network_v2.private_net.id
  }
}

// Slurm Controller Node
resource "openstack_compute_instance_v2" "slurm_controller" {
  name            = "slurm-controller"
  image_id        = data.openstack_images_image_v2.Ubuntu18.id
  flavor_name     = var.flavor
  key_pair        = openstack_compute_keypair_v2.authkeys.name
  security_groups = [openstack_networking_secgroup_v2.infra_sec_group.name]

  block_device {
    uuid                  = openstack_blockstorage_volume_v3.slurm_ctl_boot.id
    source_type           = "volume"
    boot_index            = 0
    destination_type      = "volume"
    delete_on_termination = false
  }
  network {
    uuid = openstack_networking_network_v2.private_net.id
  }
}

// Storage Instances 
// BeeGFS Storage Nodes  

resource "openstack_compute_instance_v2" "beegfs_storage_1" {
  name            = "bgfs-1"
  image_id        = data.openstack_images_image_v2.Ubuntu18.id
  flavor_name     = var.flavor
  key_pair        = openstack_compute_keypair_v2.authkeys.name
  security_groups = [openstack_networking_secgroup_v2.infra_sec_group.name]

  network {
    uuid = openstack_networking_network_v2.private_net.id
  }
}

resource "openstack_compute_instance_v2" "beegfs_storage_2" {
  name            = "bgfs-2"
  image_id        = data.openstack_images_image_v2.Ubuntu18.id
  flavor_name     = var.flavor
  key_pair        = openstack_compute_keypair_v2.authkeys.name
  security_groups = [openstack_networking_secgroup_v2.infra_sec_group.name]

  network {
    uuid = openstack_networking_network_v2.private_net.id
  }
}

resource "openstack_compute_volume_attach_v2" "beegfs_attachments_1" {
  count       =  var.beegfs_storage_vol_count
  instance_id = "${openstack_compute_instance_v2.beegfs_storage_1.id}"
  volume_id   = "${openstack_blockstorage_volume_v3.beegfs_scratch_1.*.id[count.index]}"
}

resource "openstack_compute_volume_attach_v2" "beegfs_attachments_2" {
  count       =  var.beegfs_storage_vol_count
  instance_id = "${openstack_compute_instance_v2.beegfs_storage_2.id}"
  volume_id   = "${openstack_blockstorage_volume_v3.beegfs_scratch_2.*.id[count.index]}"
}
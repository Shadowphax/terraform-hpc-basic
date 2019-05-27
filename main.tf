resource "openstack_compute_keypair_v2" "authkeys" {
  name       = "authkeys"
  public_key = "${file("${var.ssh_key_file}.pub")}"
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
  security_group_id = "${openstack_networking_secgroup_v2.infra_sec_group.id}"
}

resource "openstack_networking_secgroup_rule_v2" "www_80" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 80
  port_range_max    = 80
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = "${openstack_networking_secgroup_v2.infra_sec_group.id}"
}

resource "openstack_networking_secgroup_rule_v2" "icmp" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "icmp"
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = "${openstack_networking_secgroup_v2.infra_sec_group.id}"
}

//Networking Section 

resource "openstack_networking_network_v2" "private_net" {
  name           = "private_net"
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "private_subnet" {
  name            = "private_subnet"
  network_id      = "${openstack_networking_network_v2.private_net.id}"
  cidr            = "10.0.0.0/24"
  ip_version      = 4
  dns_nameservers = ["8.8.8.8", "8.8.4.4"]
}

resource "openstack_networking_router_v2" "private_router" {
  name                = "private_router"
  admin_state_up      = "true"
  external_network_id = "${data.openstack_networking_network_v2.private_net.id}"
}

resource "openstack_networking_router_interface_v2" "private_router_port" {
  router_id = "${openstack_networking_router_v2.private_router.id}"
  subnet_id = "${openstack_networking_subnet_v2.private_subnet.id}"
}

// Define Floating IP Pool 
resource "openstack_networking_floatingip_v2" "floating_ip" {
  pool = "${var.pool}"
}
resource "openstack_compute_floatingip_associate_v2" "headnode_floating_ip" {
  floating_ip = "${openstack_networking_floatingip_v2.floating_ip.address}"
  instance_id = "${openstack_compute_instance_v2.slurm_headnode.id}"
  provisioner "remote-exec" {
      inline = [
      "echo 'Beginning the provisioner exec....'",
      "sudo apt-get -y update",
      "sudo apt-get -y install python3-pip wget unzip",
      "sudo pip3 install ansible",
    ]
      connection {
       host        = "${openstack_networking_floatingip_v2.floating_ip.address}"
       user        = "${var.ssh_user_name}"
       private_key = "${file(var.ssh_key_file)}"
    }
  }
}

// Compute Instances 
// Slurm Headnode 
resource "openstack_compute_instance_v2" "slurm_headnode" {
  name            = "headnode"
  image_name      = "${var.image}"
  flavor_name     = "${var.flavor}"
  key_pair        = "${openstack_compute_keypair_v2.authkeys.name}"
  security_groups = ["${openstack_networking_secgroup_v2.infra_sec_group.name}"]
 
  block_device {
    uuid                  = "${openstack_blockstorage_volume_v3.slurm_boot.id}"
    source_type           = "volume"
    boot_index            = 0
    destination_type      = "volume"
    delete_on_termination = false
  }

  network {
    uuid = "${openstack_networking_network_v2.private_net.id}"
      }

  provisioner "local-exec" {
    command = "ansible-playbook -vvvv -i inventory/slurm-inventory ansible/controller.yml"
      }
}

// Slurm Worker Nodes 
resource "openstack_compute_instance_v2" "slurm_workers" {
  name		  = "workernode-${count.index +1}"
  count           = "${var.worker_instance_count}" 
  image_name      = "${var.image}"
  flavor_name     = "${var.flavor}"
  key_pair        = "${openstack_compute_keypair_v2.authkeys.name}"
  security_groups = ["${openstack_networking_secgroup_v2.infra_sec_group.name}"]
  network {
    uuid = "${openstack_networking_network_v2.private_net.id}"
  }
}

// Slurm Controller Node
resource "openstack_compute_instance_v2" "slurm_controller" {
  name            = "controller"
  image_name      = "${var.image}"
  flavor_name     = "${var.flavor}"
  key_pair        = "${openstack_compute_keypair_v2.authkeys.name}"
  security_groups = ["${openstack_networking_secgroup_v2.infra_sec_group.name}"]
  
  block_device {
    uuid                  = "${openstack_blockstorage_volume_v3.slurm_ctl_boot.id}"
    source_type           = "volume"
    boot_index            = 0
    destination_type      = "volume"
    delete_on_termination = false
  }
  network {
    uuid = "${openstack_networking_network_v2.private_net.id}"
  }
}
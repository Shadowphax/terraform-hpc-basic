
data "openstack_networking_network_v2" "private_net" {
  name = var.pool
}

data "openstack_networking_floatingip_v2" "floating_ip" {
  address = openstack_networking_floatingip_v2.floating_ip.address
}

/*
Generating groupvars/all.yml so that ansible can make use of these 
inputs for it's various application setup
*/ 
data "template_file" "groupvars" {
  template = file("./templates/all.yml.tpl")
  vars = {
    headnodename   = openstack_compute_instance_v2.slurm_headnode.name
    headnodeip     = openstack_compute_instance_v2.slurm_headnode.access_ip_v4
    controllername = openstack_compute_instance_v2.slurm_controller.name
    controllerip   = openstack_compute_instance_v2.slurm_controller.access_ip_v4
    workernodes    = join("\n", openstack_compute_instance_v2.slurm_workers.*.name)
    workernodesip  = join("\n", openstack_compute_instance_v2.slurm_workers.*.access_ip_v4)
    jumpbox_floatingIP = openstack_networking_floatingip_v2.floating_ip.address
    username           = var.ssh_user_name
  }
}

// Output of the all.yml 
resource "local_file" "groupvars" {
  content  = data.template_file.groupvars.rendered
  filename = "./ansible/group_vars/all.yml"
}

/* 
Generating the Ansible inventory file from nodes populated in Openstack. Increasing the variable count for worker nodes
in the variables.tf file will add those worker nodes to the inventory file under the correct group
*/
resource "local_file" "ansible_inventory" {
  count = "${length(openstack_compute_instance_v2.slurm_workers.*.name)}"
  content = "[all:vars]\nansible_ssh_common_args='-o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o ProxyCommand=\"ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -W %h:%p -q ${var.ssh_user_name}@${data.openstack_networking_floatingip_v2.floating_ip.address}\"'\nansible_user=${var.ssh_user_name}\n\n[workernodes]\n${join("\n",
            formatlist(
              "%s ansible_host=%s",
              openstack_compute_instance_v2.slurm_workers.*.name,
              openstack_compute_instance_v2.slurm_workers.*.access_ip_v4
            )
            )}\n\n[workernodes:vars]\nansible_user=${var.ssh_user_name}\n\n[headnode]\n${join("\n",
            formatlist(
              "%s ansible_host=%s",
              openstack_compute_instance_v2.slurm_headnode.*.name,
              openstack_compute_instance_v2.slurm_headnode.*.access_ip_v4
            )
            )}\n\n[headnode:vars]\nansible_user=${var.ssh_user_name}\n\n[controller]\n${join("\n",
            formatlist(
              "%s ansible_host=%s",
              openstack_compute_instance_v2.slurm_controller.*.name,
              openstack_compute_instance_v2.slurm_controller.*.access_ip_v4
            )
            )}\n\n[controller:vars]\nansible_user=${var.ssh_user_name}"     
  filename = "./inventory/slurm-inventory"
}
// Local Provisioners
resource "null_resource" "controller-ansible-deploy" {
  provisioner "local-exec" {
    command = "ansible-playbook -i inventory/slurm-inventory ansible/controller.yml --become"
  }
  depends_on = [openstack_compute_floatingip_associate_v2.headnode_floating_ip]
}

resource "null_resource" "headnode-ansible-deploy" {
  provisioner "local-exec" {
    command = "ansible-playbook -i inventory/slurm-inventory ansible/headnode.yml --become"
  }
  depends_on = [openstack_compute_floatingip_associate_v2.headnode_floating_ip]
}

#resource "null_resource" "workernode-ansible-deploy" {
#  provisioner "local-exec" {
#    command = "ansible-playbook -i inventory/slurm-inventory ansible/workernode.yml --become"
#  }
#  depends_on = [openstack_compute_floatingip_associate_v2.headnode_floating_ip]
#}
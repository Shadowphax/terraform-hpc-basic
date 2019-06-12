/* Local Provisioners */

resource "null_resource" "common-deploy" {
  triggers = {
    cluster_instance_names = "${join(",", openstack_compute_instance_v2.slurm_workers.*.name)}"
  }

  provisioner "local-exec" {
    command = "sleep 90 & echo \"Sleeping to wait for servers to settle....!\" "
  }

  provisioner "local-exec" {
    command = "ansible-playbook ansible/site.yml --become"
  }
  depends_on = [openstack_compute_floatingip_associate_v2.headnode_floating_ip]
}
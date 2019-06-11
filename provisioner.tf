// Local Provisioners

resource "null_resource" "common-deploy" {
  provisioner "local-exec" {
    command = "ansible-playbook ansible/site.yml --become"
  }
  depends_on = [openstack_compute_floatingip_associate_v2.headnode_floating_ip]
}
data "openstack_networking_network_v2" "private_net" {
  name = "${var.pool}"
}

//Obtain data from terraform data provider and push to a template file 
//which closely represents an ansible inventory file. 

data  "template_file" "slurm" {
    template = "${file("./templates/slurm.tpl")}"
    vars {
        headnodename = "${openstack_compute_instance_v2.slurm_headnode.name}"
        headnodeip = "${openstack_compute_instance_v2.slurm_headnode.access_ip_v4}"
        controllername = "${openstack_compute_instance_v2.slurm_controller.name}"
        controllerip = "${openstack_compute_instance_v2.slurm_controller.access_ip_v4}"
        jumpbox_floatingIP = "${openstack_networking_floatingip_v2.floating_ip.address}"
        username = "${var.ssh_user_name}"
    }
}
resource "local_file" "slurm_file" {
  content  = "${data.template_file.slurm.rendered}"
  filename = "./inventory/slurm-inventory"
}
//Obtain data from terraform data provider and push to a template file 
//which closely represents an ansible inventory file. 

data  "template_file" "slurm" {
    template = "${file("./templates/slurm.tpl")}"
    vars {
        headnodename = "${openstack_compute_instance_v2.slurm_headnode.name}"
        headnodeip = "${openstack_compute_instance_v2.slurm_headnode.access_ip_v4}"
        controllername = "${openstack_compute_instance_v2.slurm_controller.name}"
        controllerip = "${openstack_compute_instance_v2.slurm_controller.access_ip_v4}"
        username = "${var.ssh_user_name}"
    }
}
data  "template_file" "jumpbox" {
    template = "${file("./templates/jumpbox.tpl")}"
    vars {
        username = "${var.ssh_user_name}"
        jumpbox_floatingIP = "${openstack_networking_floatingip_v2.floating_ip.address}"
    }
}
resource "local_file" "slurm_file" {
  content  = "${data.template_file.slurm.rendered}"
  filename = "./inventory/slurm-inventory"
}
resource "local_file" "jumpbox_file" {
  content  = "${data.template_file.jumpbox.rendered}"
  filename = "./ansible/group_vars/jumpbox.yml"
}

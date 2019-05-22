# Obtain data from terraform data provider and push to a template file 
# which closely represents an ansible inventory file. 

data  "template_file" "slurm" {
    template = "${file("./templates/slurm.tpl")}"
    vars {
        headnodename = "${openstack_compute_instance_v2.headnode.name}"
    }
}

resource "local_file" "slurm_file" {
  content  = "${data.template_file.slurm.rendered}"
  filename = "./inventory/slurm-host"
}
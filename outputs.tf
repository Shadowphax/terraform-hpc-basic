output "Slurm Headnode Floating IP Address" {
  value = "${openstack_networking_floatingip_v2.floating_ip.address}"
}

output " Private IP Address " {
  value = "${openstack_compute_instance_v2.headnode.network.fixed_ip_v4}"
}
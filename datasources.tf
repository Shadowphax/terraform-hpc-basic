data "openstack_networking_network_v2" "private_net" {
  name = "${var.pool}"
}

output "Floating_IP" {
  value = openstack_networking_floatingip_v2.floating_ip.address
}
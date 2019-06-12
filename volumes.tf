# Creation Slurm Headnode Boot Volume

resource "openstack_blockstorage_volume_v3" "slurm_boot" {
  name        = "Slurm_boot"
  description = "Slurm Headnode Boot Volume"
  size        = 5
  image_id    = var.image
  enable_online_resize = true
}

# Create Slurm Controller Boot Volume 

resource "openstack_blockstorage_volume_v3" "slurm_ctl_boot" {
  name        = "Slurm_ctl_boot"
  description = "Slurm Controller Boot Volume"
  size        = 5
  image_id    = var.image
  enable_online_resize = true
}

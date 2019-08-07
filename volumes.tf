/* Creation Slurm Headnode Boot Volume */

resource "openstack_blockstorage_volume_v3" "slurm_boot" {
  name        = "Slurm_boot"
  description = "Slurm Headnode Boot Volume"
  size        = 40
  image_id    = data.openstack_images_image_v2.Ubuntu18.id
  enable_online_resize = true
}

/* Create Slurm Controller Boot Volume */

resource "openstack_blockstorage_volume_v3" "slurm_ctl_boot" {
  name        = "Slurm_ctl_boot"
  description = "Slurm Controller Boot Volume"
  size        = 40
  image_id    = data.openstack_images_image_v2.Ubuntu18.id
  enable_online_resize = true
}

/* Create BeeGFS Volume */

resource "openstack_blockstorage_volume_v3" "beegfs_scratch_1" {
  name        = "beegfs-scratch-1-vol-${count.index + 1}"
  count       = var.beegfs_storage_vol_count
  description = "BeeGFS Scratch Volumes 1"
  size        = 5
  enable_online_resize = true
}

resource "openstack_blockstorage_volume_v3" "beegfs_scratch_2" {
  name        = "beegfs-scratch-2-vol-${count.index + 1}"
  count       = var.beegfs_storage_vol_count
  description = "BeeGFS Scratch Volumes 2"
  size        = 5
  enable_online_resize = true
}



variable "flavor" {
  default = "m1.medium"
}
variable "ssh_key_file" {
  default = "~/.ssh/id_rsa"
}
variable "ssh_user_name" {
  default = "ubuntu"
}
variable "pool" {
  default = "public1"
}
variable "worker_instance_count" {
  default = "1"
}
variable "beegfs_instance_count" {
  default = "2"
}
variable "beegfs_storage_vol_count" {
  default = "3"
}

variable "image" {
  default = "Ubuntu-Bionic-18.04-amd64"
}

variable "flavor" {
  default = "ilifu-B"
}

variable "ssh_key_file" {
  default = "~/.ssh/id_rsa"
}

variable "ssh_user_name" {
  default = "ubuntu"
}

variable "pool" {
  default = "Ext_Floating_IP"
}

variable "worker_instance_count" {
  default = "2"
}


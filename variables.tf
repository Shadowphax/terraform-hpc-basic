variable "image" {
  default = "Ubuntu-Bionic-18.04"
}

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
  default = "2"
}


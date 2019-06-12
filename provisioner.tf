// Local Provisioners

resource "null_resource" "common-deploy" {
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = "sleep 60 & echo \"Sleeping to wait for servers to settle....!\" "
  }

  provisioner "local-exec" {
    command = "ansible-playbook ansible/site.yml --become"
  }
  depends_on = [local_file.ansible_inventory]
}
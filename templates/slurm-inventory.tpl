[all:vars]
ansible_ssh_common_args='-o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o ProxyCommand="ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -W %h:%p -q ${username}@${jumpbox_floatingIP}"'

[headnode]
${headnodename} ansible_ssh_user=ubuntu ansible_connection=ssh ansible_host=${headnodeip} 

[controller]
${controllername} ansible_ssh_user=ubuntu ansible_connection=ssh ansible_host=${controllerip}

[workernodes]

[all:vars]
ansible_ssh_common_args='-o StrictHostKeyChecking=no -o ProxyCommand="ssh -o StrictHostKeyChecking=no -W %h:%p -q ${username}@${jumpbox_floatingIP}"'

[headnode]
${headnodename} ansible_ssh_user=ubuntu ansible_connection=ssh ansible_host=${headnodeip} 

[controller]
${controllername} ansible_ssh_user=ubuntu ansible_connection=ssh ansible_host=${controllerip}

[workernodes]
${workernodes} ansible_host=${workernodesip}
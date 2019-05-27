[all:vars]
ansible_ssh_common_args='-o ProxyCommand="ssh -o StrictHostKeyChecking=no -W %h:%p -q ${username}@${jumpbox_floatingIP}"'

[headnodefrontend]
${headnodename} ansible_ssh_user=ubuntu ansible_connection=ssh ansible_host=${headnodeip} 

[controllermiddleware]
${controllername} ansible_ssh_user=ubuntu ansible_connection=ssh ansible_host=${controllerip}

[workernodesgroup]
${workernodes}
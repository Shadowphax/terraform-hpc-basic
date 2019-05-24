[all:vars]
ansible_ssh_common_args='-o StrictHostKeyChecking=no -o ProxyCommand="ssh -W %h:%p -q ${username}@${jumpbox_floatingIP}"'

[headnode-frontend]
${headnodename} ansible_host=${headnodeip} ansible_user=${username}

[controller-middleware]
${controllername} ansible_host=${controllerip} ansible_user=${username}
[all:vars]
ansible_ssh_common_args='-o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o ProxyCommand="ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -W %h:%p -q ${username}@${jumpbox_floatingIP}"'

[headnode]
${headnodeip}

[controller]
${controllerip}

[workernodes]
${workernodesip}
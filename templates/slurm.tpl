[headnode]
${headnodename}

[controller]
${controllerip} ansible_ssh_user=${username} ansible_become=True

[jumpbox]
${controllername} ansible_host=${controllerip}
${headnodename} ansible_host=${headnodeip}
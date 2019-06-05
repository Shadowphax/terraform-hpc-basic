# Terraform generates the /etc/hosts file for the machines to be 
# managed by dnsmasq. If you need to update this file with additional 
# variable hosts then you should run terraform plan && terraform apply 
# for the changes to take affect.

${headnodeip}  ${headnodename}
${controllerip}  ${controllername}
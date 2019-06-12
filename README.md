# Basic deployment of a SLURM HPC on OpenStack using Terraform

This repository is meant to provide an environment with which researchers can conduct the following work:
* Instantiate a set of compute nodes running SLURM
* Jupyter Hub and associated spawners to execute jobs on SLURM

## Installation

Download the Terraform compress file from [Terraform.io](https://terraform.io) to create the environment.

```bash
unzip <filename_which_you_downloaded>
```

## Infrastructure Deployed
 - Slurm Controller
 - Slurm Headnode 
 - Worker Nodes ( The count variable defined in variables.tf)

## Usage:

1. Clone the respository </br>
`git clone https://github.com/Shadowphax/terraform-hpc-basic.git `

2. Create a new workspace for Terraform to create and managed it's state. </br>
`terraform workspace new slurm`</br>

3. Download the relevant Terraform plugins and  template engines. </br>
`terraform init`</br>

4. Download the ansible roles.</br>
`git submodule update --init --recursive`

5. Execute the `plan` to verify the creation of infrastructure. </br>
`terraform plan -out plan.out`</br>

6. Execute the `apply` to update the infrastructure </br>
`terraform apply plan.out`</br>

## Adding additional Ansible Roles

I split the location of ansible roles into two locations. The first location is a role path ```internal-role``` which is relevant internally, example: ```common``` plays. The other is relevent to external roles - ```galaxy-roles```.The role update paths are located in the ansible.cfg. </br>
</br>
Adding more ansible roles is simply finding the role on git and executing - ```git submodule add <url> <path_to_role_and_module_name>```</br>
For example: ```git submodule add https://github.com/geerlingguy/ansible-role-nfs.git ansible/galaxy-roles/geerlingguy.nfs``` - it gets added to the .gitmodule file and this file you can check into your own fork of this project. Please do not submit PR's for the addition of roles as this project is meant to be kept miminalistic and simple.

## Openstack Credentials
Source credentials from your RC file downloadable from within OpenStack Dashboard. 

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## License

[Apache 2.0](http://www.apache.org/licenses/)

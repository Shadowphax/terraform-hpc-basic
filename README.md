# Deployment of a basic HPC Cluster on the iLifu OpenStack Research Cloud using Terraform and Ansible
<img src="images/slurm.png" width="100" height="100">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<img src="images/beegfs.png" width="150" height="100">

## Goal

The goal is to provide researchers with a zero-touch provisioned HPC cluster and parallel BeeGFS storage attached. The environment scales both slurm worker nodes and BeeGFS storage nodes without any downtime required. The deployment is not limited to the iLifu Cloud but is limited to only run on OpenStack environments.</br>
</br>
The intended use-case is for researchers who require short-term compute capacity and storage capabilities to quickly deploy a cluster on the iLifu OpenStack Research Cloud. </br>

## Nota Bene

This is a completely separate enviroment and has no bearing on the existing BeeGFS storage attached to the iLifu Cloud. </br>

## Installation

Download the Terraform compress file from [Terraform.io](https://terraform.io) to create the environment.

```bash
unzip <filename_which_you_downloaded>
```

## Infrastructure Deployed
 - Slurm Headnode
 - Slurm Controller
 - Slurm Worker Nodes
 - BeeGFS Storage


## Usage

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

1. Update the requirements.yml file in order to add ansible roles.
2. Execute `ansible-galaxy install -r requirements.yml` for installation.</br>

## Openstack Credentials
Source credentials from your RC file downloadable from within OpenStack Dashboard.

## Contributing
Pull requests are welcome. For major changes, not for Ansible roles. Please open an issue first to discuss what you would like to change.

## License

[Apache 2.0](http://www.apache.org/licenses/)

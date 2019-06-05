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

## Usage

1. Clone the respsitory </br>
`git clone https://github.com/Shadowphax/terraform-hpc-basic.git `

2. Create a new workspace for Terraform to create and managed it's state. </br>
`terraform workspace new slurm`</br>

3. Download the relevant Terraform plugins and  template engines. </br>
`terraform init`</br>

4. Execute the `plan` to verify the creation of infrastructure. </br>
`terraform plan -out plan.out`</br>

5. Execute the `apply` to update the infrastructure </br>
`terraform apply plan.out`</br>

## Openstack Credentials
Source credentials from your RC file downloadable from within OpenStack Dashboard. 

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## License

[Apache 2.0](http://www.apache.org/licenses/)

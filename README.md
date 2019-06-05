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

```bash
git clone https://github.com/Shadowphax/terraform-hpc-basic.git
terraform workspace new slurm ( The identifier "slurm" can be anything. The terraform state file will reside in this location ) 
terraform init ( Download the latest plugin for Openstack Support )
terraform plan -out plan.out
terraform apply plan.out
```

## Openstack Credentials
Source credentials from your RC file downloadable from within OpenStack Dashboard. 

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## License

[Apache 2.0](http://www.apache.org/licenses/)

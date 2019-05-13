# Dynamic IAAS Research User Environments with Terraform.io on Openstack

This repository is meant to provide an environment with which researchers can conduct the following work:
* Instantiate a set of compute nodes running SLURM
* Instantiate a set of storage nodes for scratch storage with BeeGFS
* Jupyter Hub and associated spawners to execute jobs on SLURM



## Installation

Download the Terraform compress file from [Terraform.io](https://terraform.io) to create the environment.

```bash
unzip <filename_which_you_downloaded>
```

## Usage

```bash
git clone https://github.com/Shadowphax/user-enviro.git
terraform plan -out plan.out
terraform apply plan.out
```

## Openstack Credentials
Create a *provider.tf* file which will house your Openstack credentials. Place the file in the *user-enviro* directory cloned from github.
```bash
# Configure OpenStack Provider and Authentication
provider "openstack" {
  user_name   = "username"
  tenant_name = "Project_Name"
  password    = "password"
  auth_url    = "https://keystone_endpoint:5000/"
}
```

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## License
[Apache 2.0](http://www.apache.org/licenses/)

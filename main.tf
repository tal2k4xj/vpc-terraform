terraform {
  required_providers {
    ibm = {
      source = "IBM-Cloud/ibm"
      version = "~> 1.12.0"
    }
  }
}

# Configure the IBM Provider
provider "ibm" {
  region = "eu-de"
}

# Create a VPC
resource "ibm_is_vpc" "vpc" {
  name = "mytalnevpc1"
}

# Create security group
resource ibm_is_security_group "sg1" {
  name = "mysecuritygroup"
  vpc  = ibm_is_vpc.vpc.id
}

# Define ubuntu image
data ibm_is_image "ubuntu" {
  name = "ubuntu-18.04-amd64"
}

# Create VS on VPC
resource ibm_is_instance "vsi1" {
  name    = "$mysi"
  vpc     = ibm_is_vpc.vpc.id
  zone    = "eu-de1"
  keys    = [data.ibm_is_ssh_key.ssh_key_id.id]
  image   = data.ibm_is_image.ubuntu.id
  profile = "cc1-2x4"

  primary_network_interface {
    subnet          = ibm_is_subnet.subnet1.id
    security_groups = [ibm_is_security_group.sg1.id]
  }
}
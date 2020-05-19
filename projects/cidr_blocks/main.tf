locals {
  public_cidr  = cidrsubnet("10.10.32.0/22", 1, 0)
  private_cidr = cidrsubnet("10.10.32.0/22", 1, 1)

  public_azs = ["us-west-2a", "us-west-2b"]
}

module "public_subnet_addrs" {
  source = "hashicorp/subnets/cidr"

  base_cidr_block = local.public_cidr

  networks = [for az in local.public_azs :
    {
      name     = az
      new_bits = 1
    }
  ]
}

module "private_subnet_addrs" {
  source = "hashicorp/subnets/cidr"

  base_cidr_block = local.private_cidr

  networks = [
    {
      name     = "us-west-2a"
      new_bits = 1
    }
  ]
}

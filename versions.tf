terraform {
  required_version = ">= 0.14"

  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "bowdoincollege"
    workspaces {
      name = "noc-aws-global"
    }
  }
}

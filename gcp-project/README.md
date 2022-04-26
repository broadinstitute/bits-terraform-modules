# gcp-project

This terraform module creates the following resources:

* a GCP Project
* a Compute Service Account
* Compute API enabled
* Project Owner IAM role for the person running terraform
* Compute Admin role for the compute service account
* a Compute Network (`my-network`)
* an External IP Adddress (`my-instance-ip`)
* a Firewall rule for SSH access from Broad (`my-network-allow-ssh-broad`)
* a Compute Instance (`my-instance`)

Inputs:
* `billing_account` - the billing account name where this project will be billed (ex. `0A1B2C-D3E4F5-A6B7C8`)
* `costobject` - the cost object of the billing account (ex. `1234567`)
* `folder_id` - the folder ID of the GCP folder where the project will be created
* `project_id` - the project ID of the GCP project (ex. `my-fancy-project`)
* `project_name` - the name of the project (ex. `My Fancy Project`)

Example Terraform config using this module:

```
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.84.0"
    }
  }
}

module "lukas-test-project" {
  source          = "git::https://github.com/broadinstitute/bits-terraform-modules.git//gcp-project?ref=main"
  billing_account = "0A1B2C-D3E4F5-A6B7C8"
  costobject      = "1234567"
  folder_id       = "123456789012"
  project_id      = "my-fancy-project"
  project_name    = "My Fancy Project"
}
```


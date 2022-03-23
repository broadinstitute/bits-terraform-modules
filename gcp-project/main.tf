variable "additional_services" {
    default = []
}
variable "billing_account" {}
variable "costobject" {}
variable "folder_id" {}
variable "image" {
    default = "debian-10-buster-v20200413"
}
variable "machine_type" {
    default = "e2-medium"
}
variable "project_id" {}
variable "project_name" {}
variable "region" {
    default = "us-east4"
}
variable "skip_delete" {
    default = false
}
variable "zone" {
    default = "us-east4-a"
}

data "google_client_openid_userinfo" "me" {
}

output "my-email" {
  value = data.google_client_openid_userinfo.me.email
}


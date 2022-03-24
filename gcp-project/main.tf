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
data "google_storage_bucket_object_content" "internal_networks" {
  name   = "internal_networks.json"
  bucket = "broad-institute-networking"
}

output "my-email" {
  value = data.google_client_openid_userinfo.me.email
}
output "internal_networks" {
  value = data.google_storage_bucket_object_content.internal_networks.content
}


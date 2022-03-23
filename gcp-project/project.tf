resource "google_project" "project" {
  name            = var.project_name
  project_id      = var.project_id
  folder_id       = var.folder_id
  billing_account = var.billing_account

  labels = {
      billing    = lower(var.billing_account)
      costobject = "broad-${var.costobject}",
      tf_module  = "gcp-project",
  }

  skip_delete = var.skip_delete ? true : false
}

resource "google_project_service" "default_services" {
  for_each = toset([
    "compute.googleapis.com",
  ])
  project = google_project.project.project_id
  service = each.key
}

resource "google_project_service" "additional_services" {
  for_each = toset(var.additional_services)
  project = google_project.project.project_id
  service = each.key

  disable_dependent_services = false
  disable_on_destroy = false
}

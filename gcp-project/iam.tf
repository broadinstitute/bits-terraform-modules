resource "google_service_account" "compute" {
  account_id   = "compute"
  display_name = "Compute service account for ${google_project.project.project_id}"
  project      = google_project.project.project_id
}

resource "google_service_account_key" "compute-sa-key" {
  service_account_id = google_service_account.compute.name
}

resource "google_project_iam_member" "compute" {
  for_each = toset([
    "roles/compute.admin",
  ])
  project = google_service_account.compute.project
  role    = each.key
  member  = "serviceAccount:${google_service_account.compute.email}"
}

resource "google_project_iam_member" "owner" {
  for_each = toset([
    "roles/owner",
  ])
  project = google_project.project.project_id
  role    = each.key
  member  = "user:${data.google_client_openid_userinfo.me.email}"
}

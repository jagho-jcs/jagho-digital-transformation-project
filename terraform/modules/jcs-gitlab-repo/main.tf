resource "gitlab_project" "this" {
  name              = var.name
  description       = var.description

  visibility_level  = var.visibility_level
}
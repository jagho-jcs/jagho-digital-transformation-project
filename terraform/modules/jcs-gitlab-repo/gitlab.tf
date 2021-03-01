resource "gitlab_project" "this" {
  name              = var.name
  description       = var.description

  visibility_level  = var.visibility_level  // can be private, internal, public
  default_branch    = var.default_branch
}
###############################################################################
# JCS Digital Transformation GitLab Project
###############################################################################

module gitlab-repo {
  source = "../../modules/gitlab-repo"

  gitlab_token          = var.gitlab_token
  
  name                  = var.name
  description           = var.description

  visibility_level      = var.visibility_level  // can be private, internal, public
  default_branch        = var.default_branch
}
variable gitlab_token {
  type        = string
  description = "Configure the GitLab Provider"
}

variable name {
  type        = string
  description = "The name of the repository."
}

variable description {
  type        = string
  description = "A short description of the repository."
}

variable visibility_level {
  type        = string
  description = "Visibility level"
}

variable default_branch {
  default = "master"
}
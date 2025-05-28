variable "tags" {
  type = map(string)
}

variable "env" {
  type = string
}

variable "oidc_provider_url" {
  type = string
}

variable "oidc_provider_arn" {
  type = string
}
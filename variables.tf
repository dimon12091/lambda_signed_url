variable "region" {
  type    = string
  default = "eu-central-1"
}

variable "env_name" {
  type        = string
  default     = "dev"
  description = "Env name"
}

variable "domain" {
  type        = string
  default     = ""
  description = "Domain name"
}

variable "cert_domain_name" {}
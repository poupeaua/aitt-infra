

variable "project" {
  type    = string
  default = "aitt"
}

variable "env" {
  type    = string
  default = "dev"
}

variable "vpc_id" {
  type = string
}

variable "owner" {
  type    = string
  default = "Alexandre Poupeau"
}

variable "cost_center" {
  type    = string
  default = "build"
}

variable "app_core" {
  type    = string
  default = "core"
}

variable "app_angle_symbol_clf" {
  type    = string
  default = "angle-symbol-clf"
}

variable "instance_type" {
  description = "The type of EC2 instance to deploy."
  type        = string
  default     = "m7i-flex.large"
}

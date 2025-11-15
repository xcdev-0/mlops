variable "prefix" {
  type        = string
  description = "Name prefix for resources"
  default = "gennie"
}

variable "region" {
  type        = string
  description = "AWS region"
  default = "ap-northeast-2"
}

variable "awscli_profile" {
  type        = string
  description = "AWS CLI profile for auth"
  default = "default"
}
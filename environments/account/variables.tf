variable "environment" {
  type = "string"
}

variable "account_id" {
  type        = "string"
  description = "Account ID related to the environment containing a role that will be assumed"
}

variable "name" {
  type = "string"
}

variable "profile" {
  type = "string"
}

variable "state_profile" {
  type = "string"
}

variable "aws_region" {
  type = "string"
}

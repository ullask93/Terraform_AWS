variable "cidr" {
  default     = "10.0.0.0/16"
  description = "Main CIDR of the VPC"
}

variable "name" {
  default     = "my-vpc"
  description = "VPC Name"
}

variable "pub_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  description = "CIDR for public subnets"
}

variable "priv_cidr" {
  type        = list(string)
  default     = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  description = "CIDR for private subnets"
}

variable "ssh_connection" {
  default     = "0.0.0.0/0"
  description = "IP for ssh-connection"
}

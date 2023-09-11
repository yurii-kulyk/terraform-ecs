variable "vpc_cidr_block" {
  description = "CIDR Block for VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr_1" {
  description = "CIDR for first public subnet"
  default     = "10.0.1.0/24"
}

variable "public_subnet_cidr_2" {
  description = "CIDR for second public subnet"
  default     = "10.0.2.0/24"
}

variable "private_subnet_cidr_1" {
  description = "CIDR for first private subnet"
  default     = "10.0.3.0/24"
}

variable "private_subnet_cidr_2" {
  description = "CIDR for second private subnet"
  default     = "10.0.4.0/24"
}

variable "availability_zones" {
  description = "Availability zones"
  type        = list(string)
  default     = ["eu-west-2a", "eu-west-2b"]
}

variable "env_prefix" {
  description = "Prefix for environment"
  default     = "dev"
}

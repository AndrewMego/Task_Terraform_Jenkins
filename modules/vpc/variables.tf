variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
}

variable "subnet_cidrs" {
  description = "List of subnet CIDR blocks"
  type        = list(string)
}

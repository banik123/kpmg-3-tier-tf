variable "admin_user" {
  type        = string
  default     = "adminuser"
}
variable "admin_password" {
  type        = string
  default     = "admin123!"
}
variable "aks_cluster_name" {
  type        = string
  default     = "env1-test-aks"
}
variable "node_count" {
  type        = number
  default     = 3
}
variable "environment" {
  type        = string
  default     = "dev"
}


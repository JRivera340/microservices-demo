variable "dockerhub_username" {
  description = "Docker Hub username"
  type        = string
}

variable "app_namespace" {
  description = "Kubernetes namespace for the app"
  type        = string
  default     = "microservices-demo"
}

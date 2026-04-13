variable "dockerhub_username" {
  description = "Docker Hub username"
  type        = string
}

variable "app_namespace" {
  description = "Kubernetes namespace for the app"
  type        = string
  default     = "microservices-demo"
}

variable "image_tag" {
  description = "Tag for the docker images (usually commit SHA)"
  type        = string
  default     = "latest"
}

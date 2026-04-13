terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "kubernetes_namespace" "app" {
  metadata {
    name = var.app_namespace
  }
}

# --- VOTE SERVICE (JAVA) ---
resource "kubernetes_deployment" "vote" {
  metadata {
    name      = "vote"
    namespace = kubernetes_namespace.app.metadata[0].name
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "vote"
      }
    }
    template {
      metadata {
        labels = {
          app = "vote"
        }
      }
      spec {
        # PATRÓN SIDECAR: Envoy Proxy
        container {
          name  = "envoy-sidecar"
          image = "envoyproxy/envoy:v1.30.1"
          port {
            container_port = 9901
            name           = "envoy-admin"
          }
        }
        # CONTENEDOR PRINCIPAL
        container {
          name  = "vote"
          image = "${var.dockerhub_username}/vote:${var.image_tag}"
          port {
            container_port = 8080
          }
          env {
            name  = "KAFKA_BROKERS"
            value = "kafka:9092"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "vote" {
  metadata {
    name      = "vote"
    namespace = kubernetes_namespace.app.metadata[0].name
  }
  spec {
    selector = {
      app = "vote"
    }
    port {
      port        = 80
      target_port = 8080
    }
    type = "NodePort"
  }
}

# --- RESULT SERVICE (NODE.JS) ---
resource "kubernetes_deployment" "result" {
  metadata {
    name      = "result"
    namespace = kubernetes_namespace.app.metadata[0].name
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "result"
      }
    }
    template {
      metadata {
        labels = {
          app = "result"
        }
      }
      spec {
        # PATRÓN SIDECAR: Envoy Proxy
        container {
          name  = "envoy-sidecar"
          image = "envoyproxy/envoy:v1.30.1"
        }
        container {
          name  = "result"
          image = "${var.dockerhub_username}/result:${var.image_tag}"
          port {
            container_port = 4000
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "result" {
  metadata {
    name      = "result"
    namespace = kubernetes_namespace.app.metadata[0].name
  }
  spec {
    selector = {
      app = "result"
    }
    port {
      port        = 80
      target_port = 4000
    }
    type = "NodePort"
  }
}

# --- WORKER SERVICE (GO) ---
resource "kubernetes_deployment" "worker" {
  metadata {
    name      = "worker"
    namespace = kubernetes_namespace.app.metadata[0].name
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "worker"
      }
    }
    template {
      metadata {
        labels = {
          app = "worker"
        }
      }
      spec {
        # PATRÓN SIDECAR: Envoy Proxy
        container {
          name  = "envoy-sidecar"
          image = "envoyproxy/envoy:v1.30.1"
        }
        container {
          name  = "worker"
          image = "${var.dockerhub_username}/worker:${var.image_tag}"
        }
      }
    }
  }
}

# Taller 1 - Cloud Pipelines

## Descripción
Pipeline de CI/CD para el proyecto microservices-demo usando GitHub Actions, Docker y Terraform.

## Metodología
Scrum con sprints de 2 semanas. Ver [BRANCHING.md](./BRANCHING.md) para la estrategia de ramas.

## Patrones de diseño cloud

### 1. Sidecar Pattern
Cada microservicio corre junto a un proxy Envoy como contenedor sidecar. El sidecar maneja tráfico, retries, timeouts y observabilidad sin tocar el código del servicio principal.

### 2. Circuit Breaker
Implementado entre servicios para evitar cascada de fallos. Si un servicio no responde en 3 intentos, el circuito se abre y retorna una respuesta de fallback, protegiendo el resto del sistema.

## Pipelines
- **CI:** `.github/workflows/ci.yml` — build y push a Docker Hub en cada push
- **Infra:** `.github/workflows/infra.yml` — Terraform plan y apply automático

## Arquitectura
- GitHub Actions como motor de CI/CD
- Docker Hub como registry de imágenes
- Kubernetes como plataforma de despliegue
- Terraform para gestión de infraestructura como código

## Cómo correr localmente
```bash
docker-compose up --build
```

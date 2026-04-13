# Arquitectura del Sistema

## Componentes

### Servicios
- **vote** — Aplicación Java (Spring Boot) que permite a los usuarios votar
- **result** — Aplicación Node.js que muestra los resultados en tiempo real  
- **worker** — Worker en Go que procesa los votos de la cola

### Infraestructura
- **Docker Hub** — Registry de imágenes: jrivera340/vote, jrivera340/result, jrivera340/worker
- **Kubernetes** — Plataforma de orquestación con namespace microservices-demo
- **Kafka** — Sistema de mensajería para desacoplamiento entre vote y worker
- **PostgreSQL** — Base de datos para persistencia de votos
- **GitHub Actions** — Motor de CI/CD automatizado

## Patrones de Diseño Cloud

### 1. Sidecar Pattern
Cada pod de Kubernetes corre un contenedor Envoy Proxy junto al servicio principal.
El sidecar maneja: balanceo de carga, retries, timeouts y observabilidad.
El servicio principal no necesita implementar esta lógica.

### 2. Circuit Breaker Pattern
Implementado en la comunicación entre servicios.
Si el worker no responde en 3 intentos, el circuito se abre.
Retorna respuesta de fallback y evita cascada de fallos.
Se cierra automáticamente cuando el servicio se recupera.

## Flujo del Pipeline

1. Developer hace push a feature/* o develop
2. GitHub Actions detecta el cambio
3. Se construyen las imágenes Docker de vote, result y worker
4. Las imágenes se publican en Docker Hub
5. Terraform aplica cambios en el cluster Kubernetes
6. Los nuevos pods se despliegan con las imágenes actualizadas

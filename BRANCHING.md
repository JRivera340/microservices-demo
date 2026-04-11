# Estrategia de Branching

## Desarrollo (Gitflow)
- `main` — código en producción, protegida
- `develop` — integración continua del equipo
- `feature/*` — nuevas funcionalidades, se mergean a develop

## Operaciones
- `infra/*` — cambios de infraestructura con Terraform
- `staging` — ambiente de pruebas pre-producción
- `main` — trigger de deploy a producción

## Metodología: Scrum
Sprints de 2 semanas. Cada feature branch corresponde a una historia de usuario del backlog.
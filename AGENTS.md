# Instrucciones para agentes que mantienen este repositorio

Este repositorio es un kit que se instala en otros repositorios para que docentes sin formación técnica trabajen con Git y GitHub hablando con su agente de IA (Codex, Antigravity, ventana Agents de VS Code). Mientras se construye la primera versión, el plan y el registro de decisiones están en [PLAN.md](PLAN.md).

## Reglas

- **Todo en castellano.** Los textos que leerá el profesorado (`docs/`, las skills y lo que el agente les dirá) van sin jerga y sin comandos; si un término técnico es inevitable, se explica la primera vez que aparece.
- **Repositorio limpio, centrado en la última versión.** No se conservan versiones antiguas, borradores superados ni secciones obsoletas: cuando algo cambia, se reescribe. Sí se documentan las decisiones que pueden revertirse, con su motivo, en el registro de decisiones.
- **Nada inventado sobre las herramientas.** Una capacidad, ruta u opción de Codex, Antigravity, VS Code o GitHub se escribe solo si se ha comprobado en su documentación o probándola; si no, se marca como pendiente de verificar, con fecha.
- **Nada sobre GitHub remoto sin confirmación:** crear repositorios, invitar, activar Pages o cambiar reglas de ramas.
- **Las skills del kit viven en `skills/<nombre>/SKILL.md`,** la ruta que descubre `gh skill install`. No van en `.agents/skills/` de este repositorio, para que el agente de quien mantiene el kit no las cargue mientras trabaja en él.
- **Agnóstico:** nada que solo funcione en una herramienta. Las reglas van en `AGENTS.md` y las skills siguen el formato estándar (`SKILL.md` con `name` y `description`).

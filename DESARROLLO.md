# Desarrollo del kit

Guía para quien mantiene github-friendly. Mientras se construye la primera versión, las decisiones y lo pendiente están en [PLAN.md](PLAN.md); al terminarla, lo vigente pasa aquí.

## Cómo funciona

Hay tres instalaciones distintas:

| Qué | Quién y cuándo | Cómo |
|---|---|---|
| El ordenador: Git, GitHub CLI e inicio de sesión | Cada docente, una vez | Tutorial de la ayuda (`docs/instalar.md`) |
| Los archivos del kit en un proyecto | Una persona por proyecto, una vez y de nuevo para actualizar | `gh skill install` + skill `configurar-proyecto` |
| La configuración en GitHub | La persona propietaria del proyecto | Skills `configurar-proyecto` e `invitar` |

Las skills se guardan dentro de cada proyecto (`.agents/skills/`), así que el resto del equipo las recibe al traer los cambios, sin instalar nada. Codex, Antigravity y VS Code leen esa carpeta y el archivo `AGENTS.md` de la raíz.

## Estructura del repositorio

```text
README.md        cruce de caminos e instrucciones para agentes que instalan el kit
AGENTS.md        reglas para el agente de quien mantiene el kit
skills/          el kit: lo que copia gh skill install (busca skills/*/SKILL.md)
docs/            ayuda para el profesorado; GitHub Pages la publica con Jekyll
pruebas/         pruebas del script de la portada y escenarios con un GitHub simulado
```

Las skills del kit no están en `.agents/skills/` de este repositorio para que el agente de quien mantiene el kit no las cargue mientras trabaja en él.

## Qué deja el kit en un proyecto

| En el proyecto | Viene de | Se reescribe al actualizar |
|---|---|---|
| `.agents/skills/<skill>/` | `skills/<skill>/` (lo copia `gh skill install`) | Sí (`gh skill update`) |
| Bloque entre `<!-- kit:inicio` y `<!-- kit:fin -->` en `AGENTS.md` | `skills/configurar-proyecto/plantillas/bloque-kit.md` | Sí, solo el bloque |
| `.github/workflows/publicar-web.yml` | `plantillas/publicar-web.yml` | Sí |
| `.github/scripts/montar_web.py` | `plantillas/montar_web.py` | Sí |
| `.gitattributes`, `.gitignore` | `plantillas/gitattributes`, `plantillas/gitignore` | Se añaden las líneas que falten |
| `.github/pull_request_template.md` | `plantillas/pull_request_template.md` | No, si ya existe |

Las plantillas se guardan sin el punto inicial (`gitattributes`, no `.gitattributes`) y la skill las copia con su nombre real: así no dependen de que `gh skill install` copie archivos ocultos.

## Cómo escribir las skills

- **Para cualquier terminal.** La persona puede usar PowerShell (Windows) o zsh (macOS): un comando por paso, sin tuberías ni variables de la terminal, y las rutas de `gh api` entre comillas dobles (`"repos/{owner}/{repo}/pages"`). En las consultas `--jq`, nada de comillas dentro de las comillas: escapar comillas no funciona igual en PowerShell.
- **Nada interactivo.** `git commit -m "…"`, `git merge --no-edit -m "…"` (el `-m` pone el mensaje en español y el `--no-edit` evita el editor), `gh pr merge --subject "…"`, `git --no-pager log`; `gh config set prompt disabled` lo fija `empezar-sesion`. Un editor o un paginador abiertos bloquean al agente.
- **Nada que cambie el ordenador sin necesidad.** Los ajustes globales (`gh config`, `gh auth setup-git`, la identidad de Git) se comprueban antes y solo se cambian si faltan, avisando a la persona.
- **Cada camino tiene salida.** Para cada paso que puede fallar (sin conexión, sin GitHub, sin permisos, la persona dice «ahora no»), la skill dice qué hacer. Los agentes de prueba encuentran sobre todo esto: saltos entre skills que forman un bucle, casos especiales escritos después del caso general y frases finales que no encajan en todos los casos.
- **Lo que debe estar siempre activo va en el bloque del kit**, no en una skill: una skill solo se carga cuando la petición encaja con su descripción. El bloque nombra cada skill y su ruta, y dice que, si no está cargada, se lea su `SKILL.md`; así funciona aunque la herramienta no haya detectado las skills.
- **Descripciones con las frases de la persona.** La herramienta elige la skill comparando la petición con su `description`: incluye frases tal como las diría un docente («guarda», «publica»).
- **Nombres:** minúsculas y guiones, iguales al nombre de la carpeta (lo exige la especificación de Agent Skills).

## Cómo probar

```bash
python3 -W error -m unittest discover -s pruebas     # script de la portada
gh skill publish . --dry-run                          # skills según la especificación
pruebas/escenarios.sh lista                           # escenarios disponibles
pruebas/escenarios.sh preparar S3 /tmp/prueba-S3      # prepara uno
pruebas/escenarios.sh comprobar S3 /tmp/prueba-S3     # comprueba el resultado
```

Los escenarios montan un GitHub simulado: un remoto local cuyo *hook* rechaza las subidas a `main`, como la regla `proteger-main`, y un clon por docente. Entre `preparar` y `comprobar`, un agente hace de asistente de la docente en `<carpeta>/ana` (o `<carpeta>/proyecto` en S7) con la frase de prueba del escenario; S0 y S10 no necesitan agente. Las pruebas con agente deben hacerse con un agente nuevo, sin contexto de cómo se escribieron las skills, y no deben ejecutar `gh` ni cambiar la configuración global.

**Lecciones aprendidas:**

- Si la máquina tiene un `core.hooksPath` global, sustituye al *hook* del remoto simulado y `main` queda sin proteger. El script fija `core.hooksPath` en cada repositorio de prueba, y S0 comprueba que la protección funciona antes de fiarse del resto.
- `gh skill install --from-local` copia todo lo que haya en la carpeta de cada skill, también lo que Git ignora (un `__pycache__`, por ejemplo), y escribe en el *frontmatter* la ruta local de origen. Por eso las pruebas de Python no generan *bytecode*, y por eso los proyectos de prueba instalados desde una carpeta local nunca deben subirse a GitHub.
- Los agentes de prueba dan su usuario y las respuestas de la docente en el enunciado; si no, se paran en la primera pregunta y el resto del camino queda sin probar.

Lo que depende de GitHub (crear el repositorio, Pages, la regla `proteger-main`, *pull requests*, invitaciones) se prueba con un repositorio de prueba real, y el comportamiento en Codex, Antigravity y VS Code, en esas herramientas.

## Publicar una versión

1. Pasa todas las pruebas.
2. `gh skill publish --tag vX.Y.Z` valida las skills, crea la versión en GitHub y propone añadir al repositorio el tema `agent-skills`. `gh skill install` instala por defecto la última versión publicada.
3. Conviene proteger las etiquetas de versión con una regla del repositorio, para que una versión publicada no pueda cambiar.

## Datos que cambian

- **Dirección del kit.** `avidaldo/github-friendly` y `https://avidaldo.github.io/github-friendly/` aparecen en el README, en las skills, en el bloque del kit y en la ayuda. Para encontrarlas todas: `grep -rn "avidaldo" --include="*.md" .`
- **Versiones.** `gh skill` exige GitHub CLI 2.90 o posterior. El *workflow* usa `actions/checkout@v7`, `actions/configure-pages@v6`, `actions/upload-pages-artifact@v5` y `actions/deploy-pages@v5`, y el script de la portada solo la biblioteca estándar de Python.
- **Hechos sobre las herramientas.** Antes de cada versión, revalida en la documentación oficial los hechos técnicos del plan: rutas que lee cada herramienta, límites de GitHub y licencia educativa.

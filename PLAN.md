# Plan del kit: Git y GitHub para profesorado a través de agentes de IA

> **Estado:** v0.2 · 21-nov-2026 · Fase 2 (plan) pendiente de aprobación.
> Cuando la primera versión del kit esté terminada, lo que siga vigente de este plan (arquitectura y decisiones) pasa a `DESARROLLO.md` y este archivo se borra.

## 1. Qué es

Un kit que se instala en un repositorio (nuevo o ya empezado) para que docentes sin formación técnica creen webs educativas, las publiquen en GitHub Pages y trabajen varias personas en el mismo repositorio, todo hablando en lenguaje natural con su agente de IA. El agente maneja Git y GitHub por debajo; la persona nunca escribe comandos.

- **Herramientas objetivo:** Codex (principal), Antigravity y la ventana Agents de VS Code.
- **Sistemas:** Windows primero; macOS también.
- **Tamaño de equipo previsto:** unas 5 personas por repositorio.
- **Mantenimiento:** una persona técnica (Alejandro), que necesita su propia documentación de desarrollo.

**Fuera del alcance:** la formación (se planifica aparte), enseñar línea de comandos, webs que necesiten compilación (React, Vite…), organizaciones de GitHub en la primera versión (queda documentada como opción) y Claude Code como herramienta del profesorado.

## 2. Registro de decisiones

Las marcadas como *revisable* pueden cambiar según evolucione el proyecto; si cambian, se reescribe la fila con el motivo nuevo.

| Fecha | ID | Decisión | Motivo | |
|---|---|---|---|---|
| 21-nov-2026 | D1 | Un único formato para las tres herramientas: reglas en `AGENTS.md` y skills en `.agents/skills/`. Ningún archivo propio de una herramienta (`GEMINI.md`, `.github/skills/`, workflows de Antigravity) | Las tres leen esas dos rutas (sección 6); duplicar obligaría a mantener copias, y los enlaces simbólicos fallan en Windows | |
| 21-nov-2026 | D2 | Las skills operan con `git` y `gh` (GitHub CLI), no con los botones de Git de cada herramienta | La interfaz es la frase ("publica"), igual en las tres herramientas | |
| 21-nov-2026 | D3 | Cuentas personales de GitHub: el repositorio es de quien lo crea y el resto entra como colaborador | Menos conceptos al empezar | revisable: pasar a organización (sección 5.3) |
| 21-nov-2026 | D4 | Repositorios públicos por defecto | En el plan Free, Pages y la protección de ramas solo funcionan en repos públicos | revisable si se pasa a organización con GitHub Team |
| 21-nov-2026 | D5 | Se recomienda pedir la licencia educativa de GitHub, con tutorial | Da Copilot Pro (lo necesita la ventana Agents de VS Code) y GitHub Team para una futura organización | |
| 21-nov-2026 | D6 | Modelo **borrador / publicado**: una rama por persona (`borrador-<usuario>`), `main` protegida, publicar = *pull request* + fusión hecha por la propia persona | Permite guardar trabajo no listo sin publicarlo; `main` queda a salvo aunque la IA olvide una regla | revisable: rama por web en vez de por persona |
| 21-nov-2026 | D7 | Fusión siempre con *merge commit*; se desactivan *squash* y *rebase*, y no se borra la rama al fusionar | La rama de borrador vive mucho tiempo; con *squash* daría conflictos falsos en cada publicación | |
| 21-nov-2026 | D8 | Lo normal es un único repositorio grande por grupo de trabajo: una carpeta por web y un índice común en la raíz que enlaza todas; las webs no se compilan | Un repo da una sola web en Pages; el índice la convierte en un portal; una carpeta por web reduce los choques entre personas | |
| 21-nov-2026 | D9 | Las skills se guardan dentro de cada repositorio; se instalan una vez por repositorio y el resto de colaboradores las recibe al traer los cambios | Cinco personas, una sola instalación; actualizar también se hace una vez | |
| 21-nov-2026 | D10 | Instalación con `gh skill install`; si la *preview* falla, plan B: instrucciones para agentes en el README del kit | Comando oficial, `gh` ya es requisito, fija versiones y permite `gh skill update` | revisable mientras `gh skill` esté en *preview* |
| 21-nov-2026 | D11 | Las reglas del kit entran en el `AGENTS.md` del proyecto entre dos marcadores (`<!-- kit:inicio -->` y `<!-- kit:fin -->`), el **bloque del kit** | Se puede actualizar sin pisar lo que haya escrito el docente | |
| 21-nov-2026 | D12 | Documentación en dos puertas: web de ayuda para el profesorado (`docs/`, publicada con Pages) y `DESARROLLO.md` para quien mantiene el kit; el README las cruza | Dos públicos con necesidades opuestas | |
| 21-nov-2026 | D13 | Todo en castellano | Las personas usuarias pueden pedir después contenido en gallego a su agente | revisable |
| 21-nov-2026 | D14 | En el repositorio del kit, las skills viven en `skills/<nombre>/SKILL.md`, no en `.agents/skills/` | Es la ruta que descubre `gh skill install`, y así el agente de quien mantiene el kit no las carga mientras trabaja en él | |
| 21-nov-2026 | D15 | El repositorio del kit se llama `github-friendly` | Corto, fácil de dictar y dice el objetivo; la primera línea del README y de la ayuda aclara que no es un producto oficial de GitHub | |
| 21-nov-2026 | D16 | La portada se genera con GitHub Actions en cada publicación: `montar_web.py` lee el `<title>` y la `<meta name="description">` de cada carpeta con `index.html`. Si la raíz tiene su propio `index.html`, se respeta y no se genera portada | La portada es un archivo derivado: si nadie lo edita, no produce conflictos ni se desfasa. Además, solo se publican las webs, no `AGENTS.md` ni las skills | |
| 21-nov-2026 | D17 | Las pruebas de las skills se hacen primero con agentes Claude sin contexto previo sobre un GitHub simulado; después, en Codex y en las otras herramientas reales | Codex CLI no está instalado en la máquina de desarrollo; las pruebas en las herramientas reales siguen siendo necesarias antes de cada versión | |

## 3. Arquitectura

### 3.1 Tres instalaciones distintas

| Qué | Quién y cuándo | Cómo |
|---|---|---|
| El ordenador: Git, GitHub CLI e inicio de sesión | Cada docente, una vez | Tutorial de la web de ayuda (sección 5.1) |
| Los archivos del kit en el repositorio | Una persona por repositorio, una vez, y de nuevo para actualizar | `gh skill install` + skill `configurar-proyecto` |
| La configuración en GitHub: Pages, protección de `main`, ajustes de fusión, invitaciones | La persona propietaria del repositorio | Skills `configurar-proyecto` e `invitar` |

### 3.2 Recorridos de una persona usuaria

1. **Preparar el ordenador** (una vez): sigue el tutorial e inicia sesión en GitHub.
2. **Instalar el kit en un proyecto** (nuevo o ya empezado): abre la carpeta en su herramienta y escribe la frase del README («Instala el kit de github.com/…/… en este proyecto»). El README tiene un apartado para agentes con el comando exacto, `gh skill install avidaldo/github-friendly --all --dir .agents/skills`, y la orden de seguir después `configurar-proyecto`.
3. **Unirse al proyecto de otra persona:** acepta la invitación de GitHub y clona el repositorio desde su herramienta; las skills ya vienen dentro.
4. **Día a día:** «empiezo» → trabaja → «guarda» (sube a su borrador) → «publica» (pasa a `main` y se actualiza la web).

### 3.3 Qué deja `configurar-proyecto` en el proyecto

Cada caso de partida tiene su respuesta, y repetir la skill no rompe nada (es idempotente):

- **Carpeta sin Git:** crea el repositorio local y el de GitHub y sube el contenido.
- **Repositorio local sin GitHub:** lo crea en GitHub y lo sube.
- **Ya en GitHub, con gente subiendo directamente a `main`:** crea las ramas de borrador y avisa antes de activar la protección.
- **Ya tiene `AGENTS.md`:** añade o sustituye solo el bloque del kit.
- **Ya tiene skills propias:** no toca ninguna que no sea del kit; si un nombre coincide, avisa y para.
- **Necesita compilación** (`package.json` con paso de *build*): avisa de que está fuera del alcance y para.

Archivos que añade: el bloque del kit en `AGENTS.md`, `.gitattributes` (finales de línea iguales en Windows y macOS; sin esto, un archivo tocado en Windows aparece entero como cambiado en macOS), `.gitignore`, `.github/pull_request_template.md`, el *workflow* que publica (`.github/workflows/publicar-web.yml`) y el script que monta la web y su portada (`.github/scripts/montar_web.py`).

Ajustes en GitHub (solo la persona propietaria puede hacerlos): Pages publicado desde GitHub Actions; un *ruleset* (conjunto de reglas de rama) sobre `main` que exige *pull request* sin aprobaciones, impide el *force push* e impide borrar la rama; *merge commit* como única forma de fusión; no borrar la rama al fusionar.

### 3.4 Skills de la primera versión

| Skill | Se activa cuando la persona dice… | Qué hace |
|---|---|---|
| `configurar-proyecto` | «configura este proyecto», «actualiza el kit» | Lo descrito en 3.3 |
| `empezar-sesion` | «empiezo», «¿qué hay de nuevo?» | Pasa a su rama de borrador (la crea si no existe), no descarta nada sin guardar, trae lo publicado en `main` y resume qué ha cambiado y quién lo cambió |
| `guardar` | «guarda», «súbelo» | Revisa qué se va a guardar (datos del alumnado, claves, archivos de más de 10 MB: pregunta qué hacer con ese archivo y nunca lo borra), hace *commit* y lo sube a su borrador; sin conexión, guarda en el ordenador |
| `publicar` | «publica», «quiero que se vea en la web» | Guarda, se pone al día con `main`, abre el *pull request*, lo fusiona, espera a que Pages termine y da el enlace |
| `resolver-conflictos` | «me sale un conflicto», o cuando Git no puede combinar | Explica en llano qué choca; propone una solución que conserve el trabajo de las dos personas; enseña qué se queda fuera y la aplica solo con el sí de la persona |
| `crear-web` | «crea una web nueva sobre…» | Crea la carpeta de la web con una página mínima (con título y descripción, que el índice usa) y dice cuál será su dirección al publicar |
| `invitar` | «invita a…» | Invita a una persona como colaboradora y explica qué tiene que hacer ella para unirse |

Para más adelante: `deshacer` («deshaz lo último», «recupera la versión de ayer de…»).

**El bloque del kit en `AGENTS.md`** recoge lo que debe estar siempre activo, porque una skill solo se carga cuando la petición encaja con su descripción: hablar sin jerga, nunca trabajar en `main`, hacer el ritual de inicio si la persona empieza a pedir cambios sin él, ofrecer guardar al terminar cada tarea, nunca usar *force push* ni borrar trabajo ajeno, no subir datos personales ni claves, y explicar los errores en vez de reintentar en bucle.

### 3.5 Estructura del repositorio del kit

```text
github-friendly/
├── README.md              # cruce de caminos: docentes → ayuda; agentes → instrucciones; mantenimiento → DESARROLLO.md
├── AGENTS.md              # reglas para el agente de quien mantiene el kit
├── DESARROLLO.md          # arquitectura, decisiones, pruebas y publicación de versiones
├── skills/                # el kit: lo que instala gh skill install
│   ├── configurar-proyecto/
│   │   ├── SKILL.md
│   │   └── plantillas/    # bloque del kit, .nojekyll, .gitattributes, plantilla de PR
│   ├── empezar-sesion/
│   ├── guardar/
│   ├── publicar/
│   ├── resolver-conflictos/
│   ├── crear-web/
│   └── invitar/
├── docs/                  # web de ayuda para el profesorado (Markdown; Pages lo convierte con Jekyll)
└── pruebas/
```

## 4. Hechos técnicos

### 4.1 Comprobados en documentación oficial (21-nov-2026)

| Hecho | Fuente |
|---|---|
| Codex lee `AGENTS.md` y las skills de `.agents/skills/` del repositorio | Documentación de OpenAI (consultada en la v0.1) |
| Antigravity lee skills de `.agents/skills/` (mantiene `.agent/skills/` por compatibilidad) y reglas de `AGENTS.md`, `GEMINI.md` y `.agents/rules/`; no aclara cuál manda si chocan | [Agent skills](https://antigravity.google/docs/skills.md), [Rules](https://antigravity.google/docs/rules.md) |
| VS Code lee skills de proyecto de `.github/skills/`, `.claude/skills/` y `.agents/skills/`; el ajuste para añadir rutas propias está obsoleto | [Use Agent Skills in VS Code](https://code.visualstudio.com/docs/copilot/customization/agent-skills) |
| La ventana Agents de VS Code está en la versión estable como *preview* desde la 1.120 (mayo de 2026) y usa Copilot | [Use the Agents window](https://code.visualstudio.com/docs/copilot/agents-app) |
| La app de Codex existe para Windows; necesita Git instalado aparte y `gh auth login` para las funciones de GitHub; su *sandbox* bloquea la red salvo aprobación | [Codex app en Windows](https://developers.openai.com/codex/app/windows), [Windows sandbox](https://learn.chatgpt.com/docs/windows/windows-sandbox.md) |
| GitHub Pages: en el plan Free solo repos públicos; en privados hace falta Pro, Team o Enterprise. La web publicada es pública aunque el repositorio sea privado (salvo Enterprise Cloud) | [What is GitHub Pages](https://docs.github.com/en/pages/getting-started-with-github-pages/what-is-github-pages) |
| `gh skill install` (gh ≥ 2.90, en *preview*): descubre skills en `skills/*/SKILL.md`; instala por defecto en el proyecto; Codex, Antigravity y Copilot comparten `.agents/skills`; `--all` instala todas sin preguntar; `--pin` fija una etiqueta o *commit*; guarda el origen en el *frontmatter* de cada skill para `gh skill update` | [gh skill install](https://cli.github.com/manual/gh_skill_install), [anuncio](https://github.blog/changelog/2026-04-16-manage-agent-skills-with-github-cli/) |
| Desde GitHub (`gh skill install avidaldo/github-friendly --all --dir .agents/skills`), cada skill queda con `metadata.github-repo`, `github-path`, `github-ref` y `github-tree-sha`, y `gh skill update --all --dir .agents/skills` las encuentra. Sin `--dir`, `gh skill update` revisa también las skills personales del ordenador | Prueba en Linux, 21-nov-2026 |
| La ayuda (`docs/`) se publica en Pages desde `main` con el tema por defecto de GitHub, y los enlaces a `.md` se convierten en enlaces a las páginas | https://avidaldo.github.io/github-friendly/, 21-nov-2026 |
| Con gh 2.105: `gh skill install <carpeta> --from-local --all --dir .agents/skills` funciona en una carpeta sin Git, copia las subcarpetas de cada skill (plantillas incluidas) y reescribe el *frontmatter* con los datos de origen; `gh skill publish --dry-run` valida las skills contra la especificación | Prueba local, 21-nov-2026 |
| Licencia educativa para docentes: GitHub Team gratis («usuarios ilimitados y repositorios privados») y Copilot Pro. No menciona GitHub Pro. Requisitos: cuenta personal de GitHub, correo del centro y documentos que prueben la relación con el centro; se pide en `github.com/settings/education/benefits` | [About GitHub Education for teachers](https://docs.github.com/en/education/about-github-education/github-education-for-teachers/about-github-education-for-teachers), [Apply as a teacher](https://docs.github.com/en/education/about-github-education/github-education-for-teachers/apply-to-github-education-as-a-teacher) |

### 4.2 Por verificar (Fase 3)

| # | Qué | Cómo |
|---|---|---|
| V1 | `gh skill install` y `gh skill update` en Windows | Prueba en Windows |
| V2 | Cada herramienta carga `AGENTS.md` y detecta skills instaladas a mitad de sesión (o hay que reiniciar). En especial la ventana Agents de VS Code | Prueba en las tres herramientas |
| V3 | Las frases de la tabla 3.4 activan la skill correcta en cada herramienta | Prueba en las tres herramientas |
| V4 | Codex: qué modo de permisos evita pedir aprobación en cada `push` o llamada a `gh` sin abrir más de lo necesario | Documentación + prueba |
| V5 | `gh auth login --web` lanzado por el agente (código de un solo uso en el chat) o hace falta la terminal | Prueba en las tres herramientas |
| V6 | *Rulesets* en repos públicos de cuentas personales Free: exigir *pull request* sin aprobaciones y que una persona colaboradora pueda fusionar el suyo | Documentación + repositorio de prueba |
| V7 | Activar Pages desde `main` y consultar el estado de la publicación con `gh api` | Repositorio de prueba |
| V8 | Desactivar *squash* y *rebase* y no borrar ramas al fusionar con `gh api` | Repositorio de prueba |
| V9 | Codex en modo Worktree y ventana Agents de VS Code: si trabajan en copias aparte del repositorio y cómo afecta a la rama de borrador | Documentación + prueba |
| V10 | GitHub Team es un plan de organización (con cuentas personales la licencia educativa no permite repos privados con Pages); estado de la pausa de altas de Copilot Pro anunciada en abril de 2026 para docentes | Página de planes de GitHub y de Copilot para docentes |
| V11 | Instalación de Git y GitHub CLI en Windows (instaladores gráficos o `winget`) y en macOS (instalador `.pkg` de `gh`; Git mediante las herramientas de Xcode) | Documentación oficial + prueba |
| V12 | Límites de tamaño: de un archivo, de un repositorio y de la web publicada en Pages, y el tráfico mensual de Pages | Documentación de GitHub |
| V14 | Los pasos de la ayuda para instalar en macOS | Un Mac real |

## 5. Documentación

### 5.1 Web de ayuda para el profesorado (`docs/`)

Sin jerga y sin comandos; cada término técnico que sea inevitable se explica la primera vez.

- **Qué es y qué consigues.**
- **Empezar en tres pasos.**
- **Tutorial: instalar Git y GitHub CLI e iniciar sesión** (Windows y macOS).
- **Tutorial: pedir la licencia educativa de GitHub:** qué da con cuenta personal (Copilot Pro) y qué solo con organización (repos privados con Pages).
- **Borrador y publicado:** cómo funciona; aquí se presentan las ramas.
- **Frases que entiende el agente.**
- **Invitar a alguien y unirse a un proyecto.**
- **¿Público o privado?**
- **Más adelante: trabajar en una organización:** cuándo compensa y qué cambia.
- **Problemas frecuentes.**

### 5.2 `DESARROLLO.md` (mantenimiento)

Arquitectura, decisiones vigentes con su motivo, cómo probar, cómo publicar versiones (etiquetas de Git que `gh skill install --pin` puede fijar) y cómo revalidar los hechos técnicos de la sección 4 antes de cada versión.

### 5.3 Pasar a organización (documentado, no implementado)

Una organización hace que los repositorios no dependan de una persona y, con GitHub Team de la licencia educativa, permite repos privados con Pages y protección de ramas. Cuesta un concepto más (miembros, equipos, permisos) y alguien que la administre. GitHub permite transferir un repositorio de una cuenta personal a una organización.

## 6. Orden de implementación (Fase 4)

- [x] `configurar-proyecto` con sus plantillas.
- [x] `empezar-sesion`, `guardar`, `publicar`, `resolver-conflictos`.
- [x] `crear-web` e `invitar`.
- [x] `pruebas/`: GitHub simulado y escenarios de la sección 7; pruebas del script de la portada.
- [x] README con el apartado para agentes, `DESARROLLO.md` y web de ayuda (`docs/`).
- [x] Dos rondas de pruebas con agentes sin contexto (S1-S13) y sus correcciones; S0 y S10, sin agente.
- [x] Crear el repositorio del kit en GitHub, registrarlo en el workspace con `ws add` y activar el Pages de la ayuda.
- [ ] Verificaciones V6, V7 y V8 con un repositorio de prueba en GitHub (**pide confirmación**: crea recursos remotos); probar `publicar` e `invitar` de punta a punta.
- [ ] Pruebas con las herramientas reales (V2-V5, V9) en Windows.
- [ ] Primera versión etiquetada; pasar lo vigente de este plan a `DESARROLLO.md` y borrar `PLAN.md`.

## 7. Pruebas (Fase 5)

### 7.1 Escenarios

Las pruebas de Git se hacen con `pruebas/escenarios.sh`: un remoto local cuyo *hook* rechaza las subidas a `main` y dos clones que representan a dos docentes. Las de GitHub (Pages, *rulesets*, *pull requests*), con un repositorio de prueba.

| # | Escenario | Resultado esperado |
|---|---|---|
| S0 | (Sin agente) Alguien intenta subir directamente a `main` del GitHub simulado | Rechazado: el simulador protege `main` como lo hará GitHub |
| S1 | Empieza sin cambios ajenos | Se pone al día sin incidencias y lo resume |
| S2 | Otra persona ha publicado; empieza sesión | Su borrador recibe lo publicado y se le resume |
| S3 | Las dos editan el mismo párrafo | Conflicto explicado en llano; la propuesta conserva ambas aportaciones y se aplica solo con el sí de la persona |
| S4 | Empieza con cambios sin guardar | No se descarta nada; pregunta |
| S5 | Está en `main` | Pasa a su borrador y lo dice |
| S6 | Guarda cuando en GitHub hay algo que guardó desde otro ordenador (la subida directa se rechazaría) | Junta los dos trabajos y sube sin forzar; le cuenta lo que llegó |
| S7 | Instalar en un proyecto con `AGENTS.md` y skills propias | Bloque del kit añadido; el resto, intacto |
| S8 | Reinstalar o actualizar el kit | Mismo resultado; nada duplicado |
| S9 | Crea una web nueva en un proyecto que ya tiene otra | Carpeta con nombre válido para una dirección, título y descripción; la portada enlaza las dos |
| S10 | Una persona en Windows y otra en macOS editan el mismo archivo | Sin cambios de archivo entero por los finales de línea |
| S11 | Hay datos personales o una clave entre los cambios | `guardar` no guarda ese archivo, pregunta qué hacer y no lo borra |
| S12 | Está en `main` con cambios sin guardar y dice «guarda» | Los cambios acaban en su borrador, en GitHub; `main` no recibe nada |
| S13 | Dice «guarda» sin conexión | Guarda en el ordenador y explica que se subirá cuando haya conexión |

### 7.2 Criterios de aceptación

- Las skills se cargan y se activan en las tres herramientas, o queda documentada la diferencia y su solución.
- En S1-S11 no se pierde trabajo de nadie.
- Un piloto de 2-3 docentes instala el kit y completa empezar → guardar → publicar sin ayuda.

**Limitación:** las pruebas con Codex, Antigravity y la ventana Agents de VS Code requieren esas aplicaciones en Windows; las tiene que hacer Alejandro o el piloto. Desde esta máquina se pueden probar Git, `gh` y la lógica de las skills.

## 8. Riesgos

| Riesgo | Mitigación |
|---|---|
| La IA no activa una skill o se salta un paso | Reglas siempre activas en el bloque del kit; `main` protegida en GitHub como red independiente de la IA |
| La IA resuelve un conflicto borrando trabajo ajeno | Regla de no descartar nada sin enseñarlo; la solución se aplica solo con el sí de la persona |
| `gh skill` cambia (está en *preview*) | Plan B documentado (D10); fijar la versión de `gh` probada en `DESARROLLO.md` |
| Datos personales o claves en un repositorio público | Regla en el bloque del kit; revisión en `guardar`; página «¿Público o privado?» |
| Codex pide permiso en cada operación con red | V4; explicarlo en la ayuda |
| El repositorio común crece sin control (imágenes, vídeos, PDF) y un archivo borrado sigue ocupando sitio en el historial | `guardar` avisa de los archivos grandes antes de guardarlos; los vídeos se enlazan, no se suben; límites en V12 |
| El repositorio común depende de una sola persona propietaria, la única que puede cambiar sus ajustes | Documentar el paso a organización (5.3) |
| Las herramientas cambian y dejan la ayuda obsoleta | Fechar los hechos técnicos y revalidarlos antes de cada versión |

## 9. Preguntas abiertas

| # | Pregunta | Valor por defecto |
|---|---|---|
| P5 | ¿Con qué licencia se publica el kit? (`gh skill publish` recomienda declararla en cada skill) | Por decidir |

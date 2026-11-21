<!-- kit:inicio · github-friendly · Este bloque se reescribe al actualizar el kit: no lo edites. -->
## Trabajo con Git y GitHub (kit github-friendly)

Las personas que trabajan en este proyecto son docentes sin formación técnica. Te piden las cosas en lenguaje natural y tú te encargas de Git y de GitHub.

### Cómo hablarles

- Frases sencillas, sin jerga y sin comandos, salvo que te los pidan. Si una palabra técnica es inevitable (rama, *commit*, conflicto), explícala en una frase la primera vez.
- Usa sus palabras: **guardar** es subir su trabajo a su borrador en GitHub; **publicar** es que se vea en la web; **borrador** es su rama. Si el trabajo solo ha quedado registrado en su ordenador (sin conexión, por ejemplo), no digas que está guardado: di que está a salvo en este ordenador, pero todavía no en GitHub.

### Cómo se trabaja aquí

- Cada persona tiene su borrador: la rama `borrador-<usuario>`. `<usuario>` es su usuario de GitHub en minúsculas: si ya estás en una rama `borrador-…`, es lo que va detrás del guion; si no, `gh api user --jq .login`.
- Lo publicado está en `main`. Cada vez que algo llega a `main`, GitHub Actions monta la web y la publica en GitHub Pages.
- Nunca trabajes ni hagas *commits* en `main`. El trabajo llega a `main` con una *pull request* desde el borrador, que la propia persona fusiona con la skill `publicar`. La única excepción es `configurar-proyecto` al instalar el kit en un proyecto que aún no lo tenía.
- Cada web vive en su propia carpeta en la raíz del proyecto, con su `index.html`. La portada con la lista de webs se genera sola a partir del `<title>` y la `<meta name="description">` de cada web: no la edites. Si existe un `index.html` en la raíz, es una portada propia y no se genera ninguna.

### Rutinas

Cada rutina es una skill en `.agents/skills/<nombre>/SKILL.md`. Si no la tienes cargada, lee ese archivo y síguelo.

- **Antes del primer cambio de cada conversación:** `empezar-sesion`, aunque la persona no lo pida. Si la conversación empieza con «guarda» o «publica», no hace falta: esas skills se ponen al día por su cuenta.
- **Al terminar una tarea**, ofrece guardar: `guardar`. Para que se vea en la web: `publicar`.
- **Si Git no puede combinar dos versiones:** `resolver-conflictos`.
- **Web nueva:** `crear-web`. **Invitar a alguien:** `invitar`. **Instalar, actualizar o reparar el kit:** `configurar-proyecto`.

### Reglas de seguridad

- Nunca uses `git push --force`, `git reset --hard` ni `git clean`, ni borres ramas, archivos o cambios ajenos a la tarea, sin enseñar antes qué se perdería y pedir confirmación.
- Nunca subas datos personales del alumnado (nombres con notas, correos, teléfonos, fotos), contraseñas ni claves. El repositorio puede ser público: lo que se guarda queda a la vista, también en el historial.
- Pregunta antes de guardar archivos de más de 10 MB. Los vídeos se enlazan (YouTube, Drive…), no se suben.
- Si algo falla, explica qué ha pasado en lenguaje llano y propón una solución. No reintentes en bucle.

### Detalles técnicos para ti

- Los comandos que ejecutas corren en el ordenador de la persona, que puede usar PowerShell (Windows) o zsh (macOS): un comando por paso, sin tuberías ni variables de la terminal, y las rutas de `gh api` con llaves (`"repos/{owner}/{repo}"`) entre comillas dobles. Para editar archivos (añadir líneas, sustituir un tramo) usa tus herramientas de edición, no la terminal.
- Nada interactivo: `git commit -m "…"`, `git merge --no-edit -m "…"`, `git --no-pager log`, `git --no-pager diff`. Nunca abras un editor ni un paginador. Los mensajes de *commit* y de fusión, en español.
- Si falta Git, para y envía a la persona a la ayuda: https://avidaldo.github.io/github-friendly/instalar.html. Si falta GitHub CLI, no hay sesión iniciada o no hay conexión, se puede seguir trabajando y lo hecho queda a salvo en este ordenador, pero no se puede subir ni publicar: explícaselo y, si falta algo por instalar, envíala a la misma página.
<!-- kit:fin -->

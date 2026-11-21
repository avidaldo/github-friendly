---
name: configurar-proyecto
description: Prepara este proyecto para trabajar en equipo con el kit github-friendly, crea el repositorio en GitHub si no existe y activa la publicación de la web. Úsala cuando la persona diga «configura este proyecto», «prepara el proyecto», «actualiza el kit» o «repara el kit», y justo después de instalar el kit. Se puede repetir sin romper nada.
---

# Configurar el proyecto

Deja el proyecto listo para el modelo borrador / publicado del bloque del kit en `AGENTS.md`. Las plantillas están en la carpeta `plantillas/`, junto a este archivo. Repetir esta skill no duplica nada: cada paso comprueba antes lo que ya existe y solo cambia lo que falta.

Antes de empezar, explica en dos o tres frases qué vas a hacer: preparar la carpeta, crear o revisar el proyecto en GitHub y activar la publicación de la web.

## 1. Comprobar el ordenador

1. `git --version` y `gh --version`. Si falta alguno, para y envía a la persona a https://avidaldo.github.io/github-friendly/instalar.html
2. `gh auth status`. Si no hay sesión iniciada, para y envíala a la misma página.
3. `gh config get prompt`. Si no dice `disabled`: `gh config set prompt disabled`, para que `gh` no se quede esperando respuestas.
4. Haz los pasos 4 y 5 de la sección 1 de la skill `empezar-sesion` (acceso de Git a GitHub, y nombre y correo). Si allí apuntas que hay que preguntar por el correo, inclúyelo en el mensaje del paso 2.4 y aplica la respuesta como indica la sección 6 de esa skill, antes de guardar nada (sección 4).

## 2. Ver de dónde partimos y preguntar una sola vez

1. `git rev-parse --is-inside-work-tree`. Si falla, la carpeta aún no usa Git: `git init -b main`.
2. Si hay un `package.json` con un script `build`, la web necesita compilarse: explica que el kit no cubre ese caso todavía y para.
3. **La rama principal debe llamarse `main`.**
   - Sin remoto `origin` (`git remote` no lo muestra): si `git branch --list main` no muestra nada pero `git branch --list master` sí, renómbrala: `git branch -m master main`. Si el proyecto tiene *commits* y no existe ninguna de las dos, pregunta cuál es la rama principal antes de seguir.
   - Con remoto: `gh repo view --json defaultBranchRef --jq .defaultBranchRef.name`. Si no es `main`, explica que el kit lo necesita y propón renombrarla. Solo si acepta: `gh api -X POST "repos/{owner}/{repo}/branches/<rama-actual>/rename" -f new_name=main`, y después `git fetch origin --prune`, `git branch -m <rama-actual> main` y `git branch -u origin/main main`.
4. Reúne en un solo mensaje lo que tengas que preguntar, para no ir pregunta a pregunta:
   - **Web en la raíz.** Si hay un `index.html` en la raíz, se publicará como portada y no se generará la lista automática de webs. Si prefiere varias webs con portada automática, propón moverla a su propia carpeta y avisa de que su dirección cambiará.
   - **Proyecto en GitHub.** Si no hay remoto `origin`, propón un nombre (el de la carpeta, en minúsculas, sin tildes y con guiones) y explica que será **público**: en el plan gratuito de GitHub es la única forma de publicar la web, y todo lo que se guarde, también el historial, quedará a la vista. Si quiere un repositorio privado, explica que necesita una cuenta de pago o una organización con la licencia educativa (https://avidaldo.github.io/github-friendly/publico-o-privado.html).
5. Con sus respuestas, sigue. Si no quiere crear todavía el proyecto en GitHub, o lo quiere privado, haz todo lo que no depende de GitHub (secciones 3, 4 y 6) y explica al final qué queda pendiente.

## 3. Archivos del kit

Las plantillas que se copian enteras, cópialas tal cual con un comando (`cp` en macOS, `Copy-Item` en Windows), no reescribiéndolas: un archivo reescrito puede cambiar sin que se note. Lo que hay que fusionar con un archivo existente (`AGENTS.md`, `.gitattributes`, `.gitignore`), edítalo con tus herramientas de edición de archivos.

1. **`AGENTS.md`:** el bloque del kit es `plantillas/bloque-kit.md`, desde la línea `<!-- kit:inicio` hasta `<!-- kit:fin -->`.
   - Si no existe `AGENTS.md`, créalo con una primera línea `# Instrucciones para agentes`, una línea en blanco y el bloque.
   - Si existe y ya tiene un bloque entre esos marcadores, sustituye solo ese tramo.
   - Si existe sin bloque, añade el bloque al final, separado por una línea en blanco.
   - No cambies nada fuera de los marcadores.
2. **`.gitattributes`:** si no existe, copia `plantillas/gitattributes`. Si existe, añade al principio las dos primeras líneas de la plantilla (el comentario y `* text=auto eol=lf`) si no están, y al final las líneas `binary` que falten.
3. **`.gitignore`:** si no existe, copia `plantillas/gitignore`. Si existe, añade al final las líneas de la plantilla que falten, comentario incluido.
4. **`.github/workflows/publicar-web.yml`:** copia `plantillas/publicar-web.yml`, sustituyendo el que hubiera. Si hay otro *workflow* en `.github/workflows/` que publique en Pages (usa `deploy-pages` o `jekyll`), pregunta antes de seguir: dos publicaciones a la vez chocarían.
5. **`.github/scripts/montar_web.py`:** copia `plantillas/montar_web.py`, sustituyendo el que hubiera.
6. **`.github/pull_request_template.md`:** copia `plantillas/pull_request_template.md` solo si no existe.
7. **Skills del kit.** `.agents/skills/` debe contener `configurar-proyecto`, `empezar-sesion`, `guardar`, `publicar`, `resolver-conflictos`, `crear-web` e `invitar`. Si falta alguna: `gh skill install avidaldo/github-friendly --all --dir .agents/skills`.

## 4. Guardar los cambios del kit

Si `git status --porcelain` no muestra nada, no hay nada que guardar: salta a la sección 5.

Para saber si `main` ya está protegida (porque esta skill se ejecutó antes), mira si el repositorio tiene la regla `proteger-main`: `gh api "repos/{owner}/{repo}/rulesets" --jq ".[].name"`. Si no hay remoto `origin`, no lo está.

- **Si el proyecto aún no tiene ningún *commit*** (`git rev-parse --verify HEAD` falla): todo lo que hay en la carpeta va a guardarse. Revísalo antes como en la sección 2 de la skill `guardar` (datos personales, claves, archivos de más de 10 MB). Después, `git add -A` y `git commit -m "Primera versión del proyecto"`.
- **Si `main` ya está protegida, o estás en un borrador:** guarda los cambios del kit con la skill `guardar` y, en la sección 6, publícalos con `publicar`.
- **Si estás en `main` y no está protegida:** guarda en `main` solo los archivos del kit: `git add AGENTS.md .gitattributes .gitignore .github .agents` y `git commit -m "Instala el kit github-friendly"`. Si la persona tenía otros cambios sin guardar, no los incluyas: irán a su borrador en la sección 6. Es la única vez que el kit guarda directamente en `main`.

**Finales de línea de lo que ya existía.** Si en la sección 3 creaste o cambiaste `.gitattributes`, el proyecto ya tenía *commits* de antes y `git status --porcelain` no muestra nada, unifica los finales de línea de los archivos existentes: `git add --renormalize .` y, si eso prepara algún archivo, regístralo como en la opción que hayas usado arriba, con el mensaje «Unifica los finales de línea». Explica que esos archivos aparecen como cambiados solo por eso. Si la persona tiene cambios sin guardar, déjalo para la próxima vez que se configure el proyecto: `--renormalize` los mezclaría con los suyos.

## 5. GitHub

Solo si el proyecto ya está en GitHub o la persona ha aceptado crearlo.

1. **Repositorio.** Si no hay remoto `origin`: `gh repo create <nombre> --public --source . --remote origin --push`.
2. **Permisos.** `gh repo view --json viewerPermission --jq .viewerPermission`. Si no es `ADMIN`, los ajustes de GitHub solo los puede hacer la persona propietaria del repositorio: díselo y salta a la sección 6.
3. **Subir lo pendiente en `main`.** Si en la sección 4 hiciste un *commit* en `main` y el repositorio ya existía, súbelo ahora, antes de protegerla: `git push origin main`.
4. **Forma de fusionar:** `gh api -X PATCH "repos/{owner}/{repo}" -F allow_merge_commit=true -F allow_squash_merge=false -F allow_rebase_merge=false -F delete_branch_on_merge=false`. Así los borradores no se borran al publicar y su historia no se aplasta.
5. **Pages.** `gh api "repos/{owner}/{repo}/pages"`.
   - Si responde «Not Found», actívalo: `gh api -X POST "repos/{owner}/{repo}/pages" -f build_type=workflow`.
   - Si existe con `"build_type": "legacy"`: `gh api -X PUT "repos/{owner}/{repo}/pages" -f build_type=workflow`.
   - Si GitHub rechaza activar Pages porque el repositorio es privado, explica las opciones de la página «Público o privado» y sigue con el resto.
6. **Proteger `main`.** `gh api "repos/{owner}/{repo}/rulesets" --jq ".[] | {id, name}"`.
   - Si no hay ninguna con el nombre `proteger-main`: `gh api -X POST "repos/{owner}/{repo}/rulesets" --input <ruta a plantillas/ruleset-main.json>`.
   - Si la hay, actualízala con su `id`: `gh api -X PUT "repos/{owner}/{repo}/rulesets/<id>" --input <ruta a plantillas/ruleset-main.json>`.
7. **Primera publicación.** Si `main` se subió antes de activar Pages, esa publicación habrá fallado: `gh workflow run publicar-web.yml --ref main`. Espera a que termine consultando cada 20 segundos `gh run list --workflow publicar-web.yml --limit 1 --json databaseId,status,conclusion`, y da la dirección: `gh api "repos/{owner}/{repo}/pages" --jq .html_url`.

## 6. Borrador y resumen

1. Lleva a la persona a su borrador con la skill `empezar-sesion` (funciona también si el proyecto aún no está en GitHub). Si en la sección 4 guardaste los cambios del kit en un borrador, publícalos ahora con `publicar`.
2. Resume en llano qué ha quedado preparado: la carpeta y, si se ha hecho, el proyecto en GitHub con su dirección, la web con su dirección y que `main` está protegida. Si algo ha quedado pendiente (crear el proyecto en GitHub, los ajustes que solo puede hacer la persona propietaria), dilo y explica que basta con repetir «configura este proyecto» cuando quiera hacerlo.
3. Termina proponiendo los siguientes pasos: «crea una web nueva sobre…» y, si el proyecto ya está en GitHub, «invita a…».

## Actualizar el kit

Cuando la persona pida actualizar el kit:

1. `gh skill update --all --dir .agents/skills`. Sin `--dir` revisaría también las skills personales del ordenador, que no son del proyecto. Si dice que una skill del kit no tiene datos de origen, reinstala: `gh skill install avidaldo/github-friendly --all --dir .agents/skills --force`.
2. Repite esta skill desde la sección 1: así el bloque de `AGENTS.md` y las plantillas quedan al día.
3. Guarda y publica los cambios con `guardar` y `publicar`. El resto del equipo los recibirá al empezar su siguiente sesión.

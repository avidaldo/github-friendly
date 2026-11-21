---
name: empezar-sesion
description: Pone a la persona en su borrador y trae lo que han publicado los demás antes de tocar nada. Úsala cuando diga «empiezo», «vamos a trabajar», «¿qué hay de nuevo?», «ponme al día» o «sincroniza», y siempre antes del primer cambio de cada conversación aunque no lo pida.
---

# Empezar sesión

Objetivo: que la persona trabaje en su borrador y con lo último que se ha publicado, sin perder nada de lo que tuviera a medias.

## 1. Preparar el ordenador

Cada comprobación solo cambia algo si hace falta. Si cambias algo, díselo a la persona en una frase: «Es la primera vez en este ordenador: dejo Git preparado para que use tu cuenta de GitHub».

1. `git --version`. Si falta Git, para y envía a la persona a https://avidaldo.github.io/github-friendly/instalar.html
2. `gh auth status`. Si falta GitHub CLI o no hay sesión iniciada, explica que puede trabajar en este ordenador, pero no subir ni ponerse al día, y envíala a la misma página. Sigue sin los pasos que usan GitHub.
3. `gh config get prompt`. Si no dice `disabled`: `gh config set prompt disabled` (así `gh` no se queda esperando respuestas).
4. `git config --global --get credential.https://github.com.helper`. Si no muestra nada: `gh auth setup-git` (así Git usa la sesión de GitHub al subir).
5. **Nombre y correo** que acompañan a cada cambio guardado:
   - Si `git config user.name` o `git config user.email` están vacíos, configúralos con su cuenta de GitHub y el correo privado que da GitHub, para no publicar su correo real: `gh api user --jq ".name // .login"` → `git config --global user.name "<resultado>"`; `gh api user --jq ".id"` y `gh api user --jq ".login"` → `git config --global user.email "<id>+<login>@users.noreply.github.com"`.
   - Si el correo no termina en `@users.noreply.github.com` y `git config --global --get github-friendly.correo-revisado` no muestra nada, apúntalo para el final del resumen (sección 6). No esperes la respuesta para seguir.

## 2. Mirar dónde estamos

1. **Fusión a medias de otra vez** (`git rev-parse -q --verify MERGE_HEAD` devuelve algo): resuélvela con la skill `resolver-conflictos`. Después sigue en el paso 2 y, al resumir (sección 6), usa `HEAD^1` como punto de partida: es el borrador de antes de esa fusión.
2. `git branch --show-current` y `git status`.
3. `<usuario>` es su usuario de GitHub en minúsculas: si ya está en una rama `borrador-…`, lo que va detrás del guion; si no, `gh api user --jq .login`. Si no hay forma de saberlo (sin conexión ni sesión), pregúntaselo.
4. **¿Está el proyecto en GitHub?** Si `git remote` no muestra `origin`, todavía no. Lleva a la persona a su borrador (`git switch borrador-<usuario>` si existe; si no, `git switch -c borrador-<usuario> main`), explica que puede trabajar en este ordenador y que, para subir y publicar, antes hay que crear el proyecto en GitHub (skill `configurar-proyecto`), y salta a la sección 6.
5. **Mira qué hay de nuevo en GitHub:** `git fetch origin --prune`. No cambia sus archivos. Si falla por falta de conexión, explica que trabajará con lo que hay en este ordenador, sigue con la sección 3 y, en la sección 5, no traigas nada.

## 3. Ir al borrador

**Primero, el caso especial: está en `main` con *commits* que no están en GitHub** (`git --no-pager log --oneline origin/main..main` muestra algo). Ese trabajo tiene que pasar a su borrador sin perderse:

1. Si su borrador existe en este ordenador o en GitHub: `git switch borrador-<usuario>` y `git merge --no-edit -m "Pasa al borrador el trabajo hecho en la versión publicada" main`. Si hay conflicto, sigue con `resolver-conflictos`. Si no existe en ninguno de los dos sitios: `git switch -c borrador-<usuario>` (lo crea con esos *commits*).
2. Comprueba que todo ha pasado: `git --no-pager log --oneline borrador-<usuario>..main` no debe mostrar nada.
3. Solo entonces devuelve `main` a lo publicado: `git branch -f main origin/main`.
4. Explica en llano que ese trabajo estaba en la copia de lo publicado que hay en su ordenador, que no llegó a publicarse ni a subirse, y que ahora está en su borrador.

**Si no es el caso especial:**

- **Si ya está en su borrador:** sigue.
- **Si su borrador existe en este ordenador o en GitHub:** `git switch borrador-<usuario>`.
- **Si no existe:** créalo a partir de lo publicado: `git switch -c borrador-<usuario> origin/main`. Explica en una frase qué es su borrador: su copia de trabajo, que puede guardar en GitHub sin que se publique.

Los cambios sin guardar viajan con la persona al cambiar de rama. Si Git se niega a cambiar porque chocarían con lo que hay en el borrador, revisa esos cambios como en la sección 2 de `guardar`, regístralos con un *commit* en la rama actual (`git add -A` y `git commit -m "<mensaje>"`) y vuelve al principio de esta sección: ahora es el caso especial.

## 4. Cambios sin guardar

Si `git status` muestra cambios sin guardar, di en llano qué archivos son y si hay algo nuevo publicado por los demás (`git --no-pager log --oneline HEAD..origin/main`). Pregunta si quiere guardarlos antes de seguir. Nunca los descartes.

- Si quiere guardarlos: sigue la skill `guardar` sin su frase final y vuelve a la sección 5.
- Si no: no traigas nada (salta a la sección 6) y avisa de que no tiene lo último publicado.

## 5. Traer lo nuevo

Apunta dónde está el borrador, que será el punto de partida del resumen: `git rev-parse HEAD`.

1. **Lo que guardó la propia persona desde otro ordenador:** si `git --no-pager log --oneline HEAD..origin/borrador-<usuario>` muestra algo, `git merge --no-edit -m "Junta lo guardado desde otro ordenador" origin/borrador-<usuario>`.
2. **Lo publicado por los demás:** si `git --no-pager log --oneline HEAD..origin/main` muestra algo, `git merge --no-edit -m "Trae lo publicado" origin/main`.
3. Si Git avisa de un conflicto, sigue con la skill `resolver-conflictos`.

## 6. Resumir

Todo en un solo mensaje, que termine con una sola pregunta.

1. **Lo que ha llegado.** Si pasaste por la sección 5 (o resolviste una fusión a medias), mira qué ha llegado desde el punto de partida: `git --no-pager log --no-merges --format="%an: %s" <punto de partida>..HEAD` y `git --no-pager diff --stat <punto de partida>..HEAD`. Resume en cinco líneas como máximo qué ha cambiado, en qué webs y quién lo ha hecho. Si no hay nada nuevo, o no se ha podido mirar, dilo en una frase.
2. **Trabajo suyo que no está en GitHub.** Si el proyecto está en GitHub y `git --no-pager log --no-merges --oneline HEAD --not origin/main origin/borrador-<usuario>` muestra algo (si su borrador aún no está en GitHub, quita `origin/borrador-<usuario>`), di que ese trabajo solo está en este ordenador.
3. **Correo.** Si lo apuntaste en la sección 1, explica que su correo aparece junto a cada cambio que guarda y que el historial puede ser público, y ofrece cambiarlo por el privado de GitHub. Apunta que ya se ha preguntado, responda lo que responda: `git config --global github-friendly.correo-revisado true`. Si acepta: `git config --global user.email "<id>+<login>@users.noreply.github.com"` y, si `git config --local --get user.email` muestra algo, también `git config user.email "<id>+<login>@users.noreply.github.com"`. Lo ya guardado conserva el correo anterior.
4. **Cierre**, según el caso:
   - Si la persona ya había pedido algo, sigue con su petición.
   - Si hay trabajo suyo que no está en GitHub: «¿Quieres que lo guarde?»
   - Si está al día: «Ya estás al día y en tu borrador. ¿Qué quieres hacer hoy?»
   - Si no ha traído lo publicado (sin conexión, sin GitHub o porque no quiso guardar): «Estás en tu borrador, pero sin lo último publicado. ¿Qué quieres hacer hoy?»

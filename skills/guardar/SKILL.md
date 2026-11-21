---
name: guardar
description: Guarda el trabajo de la persona en su borrador de GitHub, sin publicarlo en la web. Úsala cuando diga «guarda», «guárdalo», «súbelo», «haz una copia», «termino por hoy» o «cierro», y ofrécela al acabar cada tarea.
---

# Guardar

Objetivo: que el trabajo quede a salvo en GitHub, en el borrador de la persona. Guardar no publica: la web no cambia hasta que se use `publicar`.

## 1. Comprobar dónde estamos

1. Si hay una fusión a medias (`git rev-parse -q --verify MERGE_HEAD` devuelve algo), sigue con `resolver-conflictos`.
2. `<usuario>` es su usuario de GitHub en minúsculas: si la rama actual (`git branch --show-current`) empieza por `borrador-`, lo que va detrás del guion; si no, `gh api user --jq .login`. Si no hay forma de saberlo (sin conexión ni sesión), pregúntaselo.
3. Si el proyecto está en GitHub (`git remote` muestra `origin`): `git fetch origin --prune`. Si falla, apúntalo: no hay conexión con GitHub, y en la sección 4 no intentarás subir.
4. Si la rama actual no empieza por `borrador-`, lleva a la persona a su borrador siguiendo la sección 3 («Ir al borrador») de la skill `empezar-sesion`: los cambios sin guardar viajan con ella. No vuelvas a preguntar si quiere guardar: ya lo ha pedido. Apúntalo para contárselo al final.
5. `git status`. Si no hay nada que guardar, dilo y salta a la sección 4 por si quedaba algo por subir.

## 2. Revisar antes de guardar

1. Mira qué ha cambiado: `git status` y `git --no-pager diff --stat`. Para los archivos nuevos, ábrelos y lee su contenido.
2. Busca archivos que no deberían subirse:
   - **Datos personales del alumnado:** listas con nombres y notas, correos, teléfonos, DNI, fotos de alumnado.
   - **Contraseñas o claves:** archivos `.env`, textos como `password`, `api_key` o `token` seguidos de un valor.
   - **Archivos de más de 10 MB.**
3. Si encuentras alguno, no lo guardes: di qué archivo es y por qué no debería subirse, y pregunta qué prefiere. No lo borres nunca. Las opciones:
   - **Datos personales o claves:** dejarlo solo en su ordenador y apuntarlo en `.gitignore`, la lista de archivos que nunca se suben (es lo recomendable: si no se apunta, aparecerá otra vez cada vez que guarde); quitar los datos personales del archivo (por ejemplo, «Alumno 1», «Alumno 2»), o que lo mueva ella fuera de la carpeta del proyecto.
   - **Archivos grandes:** subirlo a otro sitio (YouTube, Drive…) y enlazarlo, apuntarlo en `.gitignore`, o guardarlo si de verdad hace falta en la web.
4. El resto de los cambios se puede guardar mientras tanto, si la persona quiere.

## 3. Registrar los cambios

1. `git add -A`
2. Comprueba la lista final con `git --no-pager diff --cached --stat`. Si aparece algo que no debe subirse, sácalo con `git restore --staged <archivo>` (el archivo no se toca).
3. `git commit -m "<mensaje>"`. El mensaje, en español, dice qué se ha hecho y dónde, por ejemplo «Añade la ficha de la unidad 3 a la web de Biología». Nada de «cambios» o «actualización».

## 4. Subir al borrador

1. **Si no se puede subir**, porque el proyecto no está en GitHub o porque en el paso 1.3 no hubo conexión, salta a la sección 5.
2. Si `git --no-pager log --oneline HEAD..origin/borrador-<usuario>` muestra algo, la persona guardó desde otro ordenador: `git merge --no-edit -m "Junta lo guardado desde otro ordenador" origin/borrador-<usuario>`. Apunta qué llegó (`git --no-pager log --no-merges --format="%s" HEAD^1..HEAD^2`) para contárselo. Si hay conflicto, sigue con `resolver-conflictos`.
3. `git push -u origin borrador-<usuario>`
4. Si falla:
   - **Si GitHub lo rechaza porque hay cambios nuevos** (el mensaje dice *rejected*, *fetch first* o *non-fast-forward*): `git fetch origin` y repite los pasos 2 y 3 una sola vez.
   - **Cualquier otro error** (sin conexión, sesión caducada, el proyecto ya no existe o no hay acceso): no lo reintentes.
   - **Nunca uses `--force`.**

## 5. Confirmar

Di en una o dos frases qué se ha registrado. Si la llevaste a su borrador desde otra rama o llegó algo de otro ordenador, cuéntalo también. Después, según el caso:

- **Si se ha subido:** «Está guardado en tu borrador, pero aún no se ve en la web. Cuando quieras que se vea, dime «publica».»
- **Si no se ha podido subir:** explica por qué en llano y di: «Tu trabajo está a salvo en este ordenador, pero todavía no en GitHub. Cuando tengas conexión, dime «guarda» otra vez.» Si el proyecto no está en GitHub, propón crearlo (skill `configurar-proyecto`). Si con conexión sigue fallando, comprueba la sesión (`gh auth status`) y el acceso al proyecto (`gh repo view`), y explica lo que encuentres.
- **Si `guardar` se usó dentro de otra rutina** (`empezar-sesion`, `publicar`, `configurar-proyecto`): no pongas ninguna de esas frases finales; di en una frase qué se ha guardado y vuelve a esa rutina.

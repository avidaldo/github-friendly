---
name: crear-web
description: Crea una web nueva dentro del proyecto, en su propia carpeta y lista para aparecer en la portada. Úsala cuando la persona diga «crea una web nueva», «quiero una web sobre…», «empieza una página para mi asignatura» o algo parecido.
---

# Crear una web

Cada web vive en su propia carpeta en la raíz del proyecto. Al publicar, aparece sola en la portada, con su título y su descripción.

1. Si en esta conversación aún no has hecho `empezar-sesion`, hazla antes.
2. **Título y descripción.** Sácalos de lo que ha pedido la persona y sigue sin esperar: el título dice el tema («El sistema solar») y la descripción, en una frase, para quién y para qué es («El Sol y los planetas, para 1º de ESO»); aparecerá en la portada. Solo si no ha dicho el tema, pregúntalo.
3. **Carpeta.** Elige el nombre a partir del título: minúsculas, sin tildes ni eñes, palabras separadas por guiones y corto, por ejemplo `sistema-solar`. Será parte de su dirección. Comprueba que no existe ni en su carpeta ni en lo publicado (`git ls-tree --name-only origin/main`, si el proyecto está en GitHub); si existe, elige otro.
4. Crea `<carpeta>/index.html` a partir de `plantillas/index.html` (junto a este archivo), sustituyendo `{{TITULO}}` y `{{DESCRIPCION}}`. Escapa los caracteres `&`, `<`, `>` y `"` si aparecen en esos textos.
5. **Contenido.** El tema y el curso no son contenido; contenido es lo que la web debe contar o tener (apartados, explicaciones, actividades, imágenes). Si la persona lo ha descrito, constrúyelo dentro de esa carpeta: las imágenes en `<carpeta>/imagenes/` y todos los enlaces relativos a la propia carpeta. Si no, deja la página de la plantilla y pregunta qué quiere añadir, con dos o tres ejemplos.
6. Explica:
   - El título, la descripción y la carpeta que has elegido, y que puede cambiarlos.
   - Que la web aparecerá en la portada al publicar. Si hay un `index.html` en la raíz del proyecto, la portada es propia y habrá que añadir el enlace a mano: ofrécete a hacerlo.
   - Su dirección cuando se publique: la de la web del proyecto (`gh api "repos/{owner}/{repo}/pages" --jq .html_url`) más `<carpeta>/`.
   - Que puede verla ya en su ordenador abriendo `<carpeta>/index.html` en el navegador.
7. Ofrece guardar (skill `guardar`).

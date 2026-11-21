---
name: resolver-conflictos
description: Resuelve un conflicto de Git, es decir, cuando dos personas cambiaron lo mismo y Git no sabe con qué versión quedarse, sin perder el trabajo de nadie. Úsala cuando Git avise de un conflicto al combinar cambios, cuando haya una fusión a medias o cuando la persona diga «me sale un conflicto».
---

# Resolver un conflicto

Un conflicto aparece cuando dos personas han cambiado el mismo trozo de un archivo y Git no sabe con qué versión quedarse. Lo más importante es **no perder el trabajo de nadie**, y la persona decide.

## 1. Entender qué choca

1. Archivos en conflicto: `git diff --name-only --diff-filter=U`
2. Para cada archivo:
   - Quién cambió qué: `git --no-pager log --no-merges --left-right --format="%m %an: %s" HEAD...MERGE_HEAD -- <archivo>`. Las líneas que empiezan por `<` son cambios de la persona (su borrador); las que empiezan por `>`, los que llegan.
   - Ábrelo y busca las zonas entre `<<<<<<<` y `>>>>>>>`. Lo que hay entre `<<<<<<<` y `=======` es la versión de la persona; lo que hay entre `=======` y `>>>>>>>`, la que llega.
3. Explica en llano, archivo por archivo, qué cambió cada persona y por qué chocan. Por ejemplo: «En la web de Biología, tú reescribiste la definición de célula y Luis añadió una frase en el mismo párrafo».

## 2. Proponer una solución y esperar el sí

1. Propón una versión que **conserve las aportaciones de las dos personas** siempre que sea posible, y enséñala.
2. Di qué se queda fuera, si algo. El texto original que una de las dos personas cambió a propósito no cuenta como perdido; sí cuenta cualquier cosa que alguna de ellas añadió o escribió.
3. **Aplica la solución solo cuando la persona diga que sí.** Si propone otra redacción, usa la suya.
4. Si no sabes de quién es un contenido o qué versión es la buena, pregunta. No adivines.
5. **Imágenes, PDF y otros archivos que no son texto** no se pueden mezclar: pregunta cuál conservar, o propón conservar las dos con nombres distintos.
6. Mientras espera la respuesta, el archivo tiene las marcas del conflicto. Si la persona quiere dejarlo para más tarde o hacer otra cosa antes, `git merge --abort` deja todo como estaba antes de combinar, sin perder nada; la próxima vez que empiece sesión volverá a aparecer el conflicto.

## 3. Aplicar y comprobar

1. Escribe en cada archivo la versión acordada, sin ninguna línea `<<<<<<<`, `=======` ni `>>>>>>>`.
2. Comprueba que no queda ninguna marca: `git grep -n -e "<<<<<<<" -e ">>>>>>>" -- <archivo>` no debe mostrar nada.
3. Si es una página web, revisa que el HTML sigue bien cerrado y propón a la persona abrirla en su navegador para verla.
4. Marca cada archivo como resuelto: `git add <archivo>`
5. Cuando estén todos: `git commit -m "Junta los cambios de <otra persona> en <web o archivo>"`

## 4. Seguir

Resume en una o dos frases qué se ha conservado de cada persona. Con el sí del paso 2 no hace falta otra confirmación: continúa con lo que estabas haciendo (`empezar-sesion`, `guardar` o `publicar`). Si venías de `empezar-sesion`, el resultado queda en este ordenador hasta que guarde: díselo y ofrece guardarlo.

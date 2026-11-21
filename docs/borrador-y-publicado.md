# Borrador y publicado: cómo funciona

## Dos versiones de cada cosa

En el proyecto conviven dos versiones del trabajo:

- **Lo publicado:** lo que se ve en la web. Es común a todo el equipo.
- **Tu borrador:** tu copia de trabajo. Solo cambia cuando tú trabajas, y nadie más la toca.

Es como un documento compartido en el que cada persona prepara sus cambios en su propio cuaderno y, cuando están listos, los pasa a limpio en el documento común.

En el lenguaje de Git, cada una de estas versiones es una **rama**. Lo publicado es la rama `main`, y tu borrador, la rama `borrador-` seguida de tu usuario de GitHub. Tu asistente lo sabe y se encarga de usarlas bien.

## Las tres acciones

| Le dices | Qué pasa | ¿Cambia la web? |
|---|---|---|
| **«Empiezo»** | Te pone en tu borrador y trae lo que han publicado los demás desde la última vez | No |
| **«Guarda»** | Guarda tu trabajo en tu borrador, en GitHub. Queda a salvo aunque se estropee tu ordenador | No |
| **«Publica»** | Pasa tu borrador a lo publicado. En uno o dos minutos se ve en la web | Sí |

Guarda a menudo y publica cuando algo esté listo para tu alumnado.

Al publicar, tu asistente crea una ***pull request***: una petición para incorporar tus cambios a lo publicado, que queda registrada en GitHub con lo que cambiaste. En este kit cada persona aprueba sus propias peticiones; el asistente lo hace por ti.

## Lo publicado está protegido

Nadie puede cambiar lo publicado directamente, ni siquiera por error: todo pasa antes por un borrador y una *pull request*. Así, aunque tu asistente se equivoque, la web no se estropea sin que quede constancia.

## Cuando dos personas tocan lo mismo: los conflictos

Si tú y otra persona cambiáis la misma frase, Git no sabe con qué versión quedarse: eso es un **conflicto**. No es un error ni se ha perdido nada; solo hay que decidir.

Tu asistente te explicará qué cambió cada persona y te propondrá una versión que conserve las dos aportaciones. Antes de darlo por bueno, comprueba tres cosas:

1. Que el asistente te ha explicado con claridad qué chocaba y qué ha decidido.
2. Que la página se ve bien: ábrela en tu navegador.
3. Que no se ha perdido nada de lo que había hecho la otra persona.

Para que haya pocos conflictos, cada web vive en su propia carpeta: si cada persona trabaja sobre todo en sus webs, casi nunca coincidiréis en el mismo archivo.

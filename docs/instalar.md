# Preparar el ordenador

Se hace una sola vez en cada ordenador. Necesitas tres cosas: una cuenta de GitHub, dos programas (Git y GitHub CLI) y dejar tu cuenta conectada.

- **GitHub** es el sitio web donde se guardan tus proyectos y desde donde se publican tus webs.
- **Git** es el programa que lleva la cuenta de cada cambio: quién lo hizo, cuándo y qué cambió.
- **GitHub CLI** es el programa con el que tu asistente de IA habla con GitHub por ti.

No vas a tener que usarlos directamente: los usa tu asistente.

## 1. Crear tu cuenta de GitHub

Entra en [github.com](https://github.com) y crea una cuenta con el botón de registro. Apunta tu **nombre de usuario**: es lo que tendrás que dar a quien quiera invitarte a su proyecto.

Si eres docente en activo, después puedes pedir la [licencia educativa](licencia-educativa.md), que es gratuita.

## 2. Instalar Git y GitHub CLI

### En Windows

La forma más sencilla es descargar los instaladores y aceptar las opciones que vienen marcadas:

1. **Git:** descárgalo de [git-scm.com](https://git-scm.com/downloads/win) e instálalo.
2. **GitHub CLI:** descárgalo de [cli.github.com](https://cli.github.com) e instálalo.

Si prefieres hacerlo en un solo paso, abre la aplicación **Terminal** (búscala en el menú Inicio), pega estas dos líneas y pulsa Intro:

```text
winget install --id Git.Git -e
winget install --id GitHub.cli -e
```

Cierra la Terminal cuando termine.

### En macOS

*Pendiente de probar en un Mac real.*

1. **Git:** abre la aplicación **Terminal** (está en Aplicaciones › Utilidades), escribe `git --version` y pulsa Intro. Si no está instalado, el Mac te ofrecerá instalar las «herramientas de línea de comandos»: acepta.
2. **GitHub CLI:** descarga el instalador para macOS de [cli.github.com](https://cli.github.com) e instálalo.

## 3. Conectar tu cuenta

Abre la aplicación **Terminal** (en Windows, búscala en el menú Inicio; en macOS, en Aplicaciones › Utilidades), pega esta línea y pulsa Intro:

```text
gh auth login --web --git-protocol https
```

1. Aparecerá un código de ocho caracteres. Cópialo.
2. Pulsa Intro: se abrirá GitHub en tu navegador. Si no se abre, entra tú en [github.com/login/device](https://github.com/login/device).
3. Pega el código y autoriza a **GitHub CLI**.
4. Vuelve a la Terminal: cuando diga que has iniciado sesión, ciérrala.

Ya está. No tendrás que volver a hacerlo en este ordenador.

## 4. Tu asistente de IA

Necesitas uno de estos programas: **Codex** (de OpenAI), **Antigravity** (de Google) o **VS Code** con su ventana Agents (de Microsoft, que funciona con GitHub Copilot). Con la licencia educativa de GitHub tienes Copilot Pro gratis.

Siguiente paso: volver a [Empezar en tres pasos](index.md#empezar-en-tres-pasos).

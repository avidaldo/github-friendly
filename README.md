# github-friendly

Un kit para que el profesorado cree webs educativas, las publique en internet con GitHub y trabaje en equipo sobre ellas, hablando con su asistente de IA (Codex, Antigravity o la ventana Agents de VS Code) en lugar de escribir comandos. No es un producto oficial de GitHub.

- **Si eres docente:** empieza por la [ayuda](https://avidaldo.github.io/github-friendly/).
- **Si eres un agente de IA** al que han pedido instalar este kit: sigue las instrucciones de abajo.
- **Si mantienes el kit:** lee [DESARROLLO.md](DESARROLLO.md).

## Instrucciones para agentes

Te han pedido instalar el kit github-friendly en la carpeta del proyecto que tienes abierta. Hazlo así, explicando cada paso a la persona en lenguaje llano y sin jerga:

1. Comprueba que el ordenador está preparado: `git --version`, `gh --version` (hace falta la versión 2.90 o posterior) y `gh auth status`. Si falta algo o no hay sesión iniciada en GitHub, para y envía a la persona a https://avidaldo.github.io/github-friendly/instalar.html
2. Desde la carpeta raíz del proyecto: `gh skill install avidaldo/github-friendly --all --dir .agents/skills`
   - Si ya existe en `.agents/skills/` una skill con el mismo nombre que una del kit y no viene de este kit, para y pregunta antes de sobrescribirla.
3. Lee `.agents/skills/configurar-proyecto/SKILL.md` y síguelo. No hace falta que tu herramienta haya cargado la skill: basta con leer el archivo.
4. Si al terminar la persona no ve las skills nuevas en su herramienta, dile que cierre y vuelva a abrir el proyecto.

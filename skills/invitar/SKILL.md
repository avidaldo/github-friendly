---
name: invitar
description: Invita a otra persona a trabajar en este proyecto de GitHub y le explica cómo unirse. Úsala cuando la persona diga «invita a…», «quiero que … trabaje conmigo», «añade a un compañero» o «¿cómo se une …?».
---

# Invitar a alguien

1. **El proyecto tiene que estar en GitHub.** Si `git remote` no muestra `origin`, explica que antes hay que crearlo (skill `configurar-proyecto`) y termina.
2. **Solo la persona propietaria del proyecto puede invitar.** Comprueba: `gh repo view --json viewerPermission --jq .viewerPermission`. Si no es `ADMIN`, explica que tiene que pedírselo a quien creó el proyecto y termina.
3. **Usuario de GitHub de la persona invitada.** Hace falta su usuario, no su correo. Si aún no tiene cuenta, envíale la ayuda para empezar: https://avidaldo.github.io/github-friendly/instalar.html. Comprueba que el usuario existe: `gh api "users/<usuario>" --jq .login`.
4. **Invitar:** `gh api -X PUT "repos/{owner}/{repo}/collaborators/<usuario>" -f permission=push`. Con este permiso podrá guardar en su borrador y publicar, pero no cambiar los ajustes del proyecto.
5. **Explica qué tiene que hacer la persona invitada.** Dale este texto para que se lo envíe:

   > Te he invitado a trabajar en el proyecto <owner>/<repo> de GitHub.
   > 1. Acepta la invitación en https://github.com/<owner>/<repo>/invitations (también te llegará por correo).
   > 2. Sigue la guía para unirte a un proyecto: https://avidaldo.github.io/github-friendly/unirse.html
   > 3. Cuando lo tengas abierto en tu herramienta de IA, dile «empiezo».

6. Para ver a quién se ha invitado: `gh api "repos/{owner}/{repo}/invitations" --jq ".[].invitee.login"`. Para ver quién ya colabora: `gh api "repos/{owner}/{repo}/collaborators" --jq ".[].login"`.

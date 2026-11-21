---
name: publicar
description: Publica en la web lo que la persona tiene en su borrador, pasándolo a main con una pull request. Úsala cuando diga «publica», «publícalo», «que se vea en la web», «súbelo a la web» o «quiero que lo vean».
---

# Publicar

Objetivo: que lo que hay en el borrador de la persona llegue a `main` y se vea en la web. El trabajo pasa de su borrador a `main` con una *pull request* (una petición de incorporar cambios) que la propia persona fusiona.

## 1. Preparar el borrador

1. Si el proyecto no está en GitHub (`git remote` no muestra `origin`), explica que antes hay que crearlo (skill `configurar-proyecto`) y termina.
2. Si hay cambios sin guardar o no está en su borrador, primero la skill `guardar`.
3. `<usuario>` es lo que va detrás de `borrador-` en el nombre de la rama.
4. `git fetch origin`
5. Si `git --no-pager log --oneline HEAD..origin/main` muestra algo, ponte al día con lo publicado: `git merge --no-edit -m "Trae lo publicado" origin/main`. Si hay conflicto, sigue con `resolver-conflictos` y vuelve aquí.
6. `git push -u origin borrador-<usuario>`
7. Si `git --no-pager log --oneline origin/main..HEAD` no muestra nada, no hay nada nuevo que publicar: dilo y termina.

## 2. Pull request

1. Mira si ya hay una abierta desde su borrador: `gh pr list --head borrador-<usuario> --state open --json number,url`.
2. Si no la hay, créala:
   - Título: una frase que resuma lo que se publica, por ejemplo «Ficha de la unidad 3 en la web de Biología».
   - Cuerpo: dos o tres frases en llano con qué cambia y en qué webs, a partir de `git --no-pager log --no-merges --format="%s" origin/main..HEAD`.
   - `gh pr create --base main --head borrador-<usuario> --title "<título>" --body "<cuerpo>"`
3. Fusiónala: `gh pr merge <número> --merge --subject "Publica: <título>"`. Nunca `--squash`, `--rebase` ni `--delete-branch`: el borrador se sigue usando.
4. Si GitHub no deja fusionar, explica el motivo en llano (`gh pr view <número> --json mergeable,mergeStateStatus`) y para.

## 3. Esperar a que se publique

1. El *commit* publicado: `gh pr view <número> --json mergeCommit --jq .mergeCommit.oid`.
2. Busca su publicación: `gh run list --workflow publicar-web.yml --branch main --limit 5 --json databaseId,headSha,status,conclusion`, y quédate con la que tenga ese `headSha`. Puede tardar unos segundos en aparecer.
3. Consulta cada 20 segundos `gh run view <databaseId> --json status,conclusion` hasta que `status` sea `completed`. Suele tardar uno o dos minutos; mientras, di a la persona que se está publicando.
4. **Si `conclusion` es `success`:** la dirección de la web es `gh api "repos/{owner}/{repo}/pages" --jq .html_url`. Da el enlace a la portada y a cada web que haya cambiado (la dirección más el nombre de su carpeta y una barra). Avisa de que, si no ve el cambio, recargue la página.
5. **Si falla:** `gh run view <databaseId> --log-failed`. Explica en llano qué ha pasado y que la web sigue mostrando la versión anterior. No lo reintentes más de una vez.

## 4. Dejar el borrador al día

1. `git fetch origin`
2. `git merge --no-edit -m "Trae lo publicado" origin/main`
3. `git push origin borrador-<usuario>`

Termina con una frase: qué se ha publicado y el enlace.

#!/usr/bin/env bash
# Prepara y comprueba los escenarios de prueba del kit con un GitHub simulado:
# un remoto local (git init --bare) cuyo hook rechaza las subidas a main, como la regla
# proteger-main, y un clon por docente (ana y berta), cada una en su borrador.
#
# Uso:
#   pruebas/escenarios.sh preparar  <escenario> <carpeta nueva>
#   pruebas/escenarios.sh comprobar <escenario> <carpeta>
#   pruebas/escenarios.sh lista
#
# Entre preparar y comprobar, un agente hace de asistente de la docente en <carpeta>/ana
# (o en <carpeta>/proyecto en S7) con la frase de prueba del escenario.
set -euo pipefail

KIT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PLANTILLAS="$KIT/skills/configurar-proyecto/plantillas"

declare -A FRASES=(
  [S0]="(sin agente: comprueba el propio GitHub simulado)"
  [S1]="empiezo"
  [S2]="empiezo"
  [S3]="empiezo"
  [S4]="empiezo"
  [S5]="empiezo"
  [S6]="guarda"
  [S7]="instala el kit en este proyecto y configúralo; después, configúralo otra vez"
  [S9]="crea una web nueva sobre el sistema solar para 1º de ESO"
  [S10]="(sin agente)"
  [S11]="guarda"
  [S12]="guarda"
  [S13]="guarda"
)

FRASE_ORIGINAL="La célula es la unidad básica de la vida."
FRASE_ANA="La célula es la unidad estructural y funcional de los seres vivos."
FRASE_BERTA="Fue descrita por Robert Hooke en 1665."
ACTIVIDAD="<p>Actividad: dibuja una célula y señala sus partes.</p>"

# ---------------------------------------------------------------- preparación

# Cada repositorio de prueba ignora los hooks y el rerere globales de la máquina, como el ordenador de un docente.
configurar_identidad() {
  git -C "$1" config user.name "$2"
  git -C "$1" config user.email "$3"
  git -C "$1" config core.autocrlf false
  git -C "$1" config core.hooksPath "$BASE/.sin-hooks"
  git -C "$1" config rerere.enabled false
}

copiar_plantillas_del_kit() {
  local destino="$1"
  { printf '# Instrucciones para agentes\n\n'; cat "$PLANTILLAS/bloque-kit.md"; } > "$destino/AGENTS.md"
  cp "$PLANTILLAS/gitattributes" "$destino/.gitattributes"
  cp "$PLANTILLAS/gitignore" "$destino/.gitignore"
  mkdir -p "$destino/.github/workflows" "$destino/.github/scripts"
  cp "$PLANTILLAS/publicar-web.yml" "$destino/.github/workflows/"
  cp "$PLANTILLAS/montar_web.py" "$destino/.github/scripts/"
  cp "$PLANTILLAS/pull_request_template.md" "$destino/.github/"
}

escribir_web_de_biologia() {
  mkdir -p "$1/biologia"
  cat > "$1/biologia/index.html" <<EOF
<!doctype html>
<html lang="es">
<head>
  <meta charset="utf-8">
  <title>La célula</title>
  <meta name="description" content="Biología de 1º de ESO">
</head>
<body>
  <h1>La célula</h1>
  <p>$FRASE_ORIGINAL</p>
  <p>Hay células procariotas y eucariotas.</p>
</body>
</html>
EOF
}

preparar_base() {
  git init -q --bare -b main "$BASE/remoto.git"
  cat > "$BASE/remoto.git/hooks/pre-receive" <<'EOF'
#!/usr/bin/env bash
while read -r _ _ referencia; do
  if [ "$referencia" = "refs/heads/main" ] && [ ! -e "$GIT_DIR/permitir-main" ]; then
    echo "main está protegida: los cambios llegan con una pull request" >&2
    exit 1
  fi
done
EOF
  chmod +x "$BASE/remoto.git/hooks/pre-receive"
  # Sin esto, un core.hooksPath global de la máquina sustituiría al hook y main quedaría sin proteger.
  git -C "$BASE/remoto.git" config core.hooksPath "$BASE/remoto.git/hooks"

  local semilla="$BASE/.semilla"
  git init -q -b main "$semilla"
  configurar_identidad "$semilla" "Coordinación" "coordinacion@example.invalid"
  (cd "$semilla" && gh skill install "$KIT" --from-local --all --dir .agents/skills > /dev/null)
  copiar_plantillas_del_kit "$semilla"
  escribir_web_de_biologia "$semilla"
  git -C "$semilla" add -A
  git -C "$semilla" commit -q -m "Primera versión del proyecto"
  git -C "$semilla" remote add origin "$BASE/remoto.git"
  touch "$BASE/remoto.git/permitir-main"
  git -C "$semilla" push -q origin main main:borrador-ana main:borrador-berta
  rm "$BASE/remoto.git/permitir-main"

  clonar ana "Ana Docente" "ana@example.invalid"
  clonar berta "Berta Docente" "berta@example.invalid"
}

clonar() {
  local persona="$1" carpeta="${4:-$1}"
  git clone -q "$BASE/remoto.git" "$BASE/$carpeta"
  configurar_identidad "$BASE/$carpeta" "$2" "$3"
  git -C "$BASE/$carpeta" switch -q "borrador-$persona"
}

# Simula una pull request fusionada: el borrador entra en main con un merge commit.
publicar_simulado() {
  local persona="$1" clon="$BASE/$1"
  git -C "$clon" push -q origin "borrador-$persona"
  git -C "$clon" fetch -q origin
  git -C "$clon" switch -q main
  git -C "$clon" merge -q --ff-only origin/main
  git -C "$clon" merge -q --no-ff --no-edit -m "Merge pull request from borrador-$persona" "borrador-$persona"
  touch "$BASE/remoto.git/permitir-main"
  git -C "$clon" push -q origin main
  rm "$BASE/remoto.git/permitir-main"
  git -C "$clon" switch -q "borrador-$persona"
  git -C "$clon" merge -q --ff-only origin/main
  git -C "$clon" push -q origin "borrador-$persona"
}

berta_publica_quimica() {
  mkdir -p "$BASE/berta/quimica"
  printf '<!doctype html>\n<html lang="es"><head><meta charset="utf-8"><title>Química</title><meta name="description" content="Química de 3º de ESO"></head><body><h1>Química</h1></body></html>\n' \
    > "$BASE/berta/quimica/index.html"
  git -C "$BASE/berta" add -A
  git -C "$BASE/berta" commit -q -m "Añade la web de Química"
  publicar_simulado berta
}

anotar_referencias_iniciales() {
  git -C "$BASE/remoto.git" rev-parse main > "$BASE/.main-inicial"
  git -C "$BASE/remoto.git" rev-parse borrador-ana > "$BASE/.borrador-ana-inicial"
}

preparar() {
  local escenario="$1"
  [ -e "$BASE" ] && { echo "La carpeta $BASE ya existe: usa una nueva." >&2; exit 2; }
  mkdir -p "$BASE/.sin-hooks"
  # La preparación no usa la configuración global de Git de esta máquina.
  export GIT_CONFIG_GLOBAL="$BASE/.gitconfig-vacio"
  : > "$GIT_CONFIG_GLOBAL"
  case "$escenario" in
    S0 | S1 | S9) preparar_base ;;
    S2) preparar_base; berta_publica_quimica ;;
    S3)
      preparar_base
      sed -i "s|$FRASE_ORIGINAL|$FRASE_ORIGINAL $FRASE_BERTA|" "$BASE/berta/biologia/index.html"
      git -C "$BASE/berta" commit -q -am "Añade quién descubrió la célula"
      publicar_simulado berta
      sed -i "s|$FRASE_ORIGINAL|$FRASE_ANA|" "$BASE/ana/biologia/index.html"
      git -C "$BASE/ana" commit -q -am "Mejora la definición de célula"
      git -C "$BASE/ana" push -q origin borrador-ana
      ;;
    S4)
      preparar_base; berta_publica_quimica
      sed -i "s|</body>|  $ACTIVIDAD\n</body>|" "$BASE/ana/biologia/index.html"
      ;;
    S5)
      preparar_base
      git -C "$BASE/ana" switch -q main
      sed -i "s|</body>|  $ACTIVIDAD\n</body>|" "$BASE/ana/biologia/index.html"
      git -C "$BASE/ana" commit -q -am "Añade una actividad"
      ;;
    S6)
      preparar_base
      clonar ana "Ana Docente" "ana@example.invalid" ana-portatil
      printf '<!doctype html>\n<html lang="es"><head><meta charset="utf-8"><title>Glosario</title></head><body><p>Célula: unidad básica.</p></body></html>\n' \
        > "$BASE/ana-portatil/biologia/glosario.html"
      git -C "$BASE/ana-portatil" add -A
      git -C "$BASE/ana-portatil" commit -q -m "Añade el glosario"
      git -C "$BASE/ana-portatil" push -q origin borrador-ana
      git -C "$BASE/ana-portatil" rev-parse HEAD > "$BASE/.commit-portatil"
      sed -i "s|</body>|  $ACTIVIDAD\n</body>|" "$BASE/ana/biologia/index.html"
      ;;
    S7)
      local proyecto="$BASE/proyecto"
      git init -q -b main "$proyecto"
      configurar_identidad "$proyecto" "Ana Docente" "ana@example.invalid"
      printf '# Mi proyecto\n\nUsa siempre un tono formal en las webs.\n' > "$proyecto/AGENTS.md"
      mkdir -p "$proyecto/.agents/skills/mi-skill" "$proyecto/historia"
      printf -- '---\nname: mi-skill\ndescription: Skill propia de la docente.\n---\n\nSaluda.\n' \
        > "$proyecto/.agents/skills/mi-skill/SKILL.md"
      printf 'borradores/\n' > "$proyecto/.gitignore"
      printf '<!doctype html>\n<html lang="es"><head><meta charset="utf-8"><title>Historia</title></head><body></body></html>\n' \
        > "$proyecto/historia/index.html"
      git -C "$proyecto" add -A
      git -C "$proyecto" commit -q -m "Primera versión"
      cp "$proyecto/.agents/skills/mi-skill/SKILL.md" "$BASE/.mi-skill-original"
      return
      ;;
    S10)
      preparar_base
      mkdir -p "$BASE/ana/fisica"
      printf '<!doctype html>\r\n<html lang="es">\r\n<head><meta charset="utf-8"><title>Física</title></head>\r\n<body></body>\r\n</html>\r\n' \
        > "$BASE/ana/fisica/index.html"
      git -C "$BASE/ana" add -A
      git -C "$BASE/ana" commit -q -m "Añade la web de Física escrita en Windows"
      ;;
    S11)
      preparar_base
      printf 'nombre,apellidos,nota\nLucía,Pérez Gómez,7.5\nMarcos,Ruiz Díaz,4\n' > "$BASE/ana/biologia/notas-alumnado.csv"
      ;;
    S12)
      preparar_base
      git -C "$BASE/ana" switch -q main
      sed -i "s|</body>|  $ACTIVIDAD\n</body>|" "$BASE/ana/biologia/index.html"
      ;;
    S13)
      preparar_base
      sed -i "s|</body>|  $ACTIVIDAD\n</body>|" "$BASE/ana/biologia/index.html"
      # Sin conexión: el remoto deja de estar disponible.
      git -C "$BASE/ana" remote set-url origin "$BASE/sin-conexion.git"
      ;;
    *) echo "Escenario desconocido: $escenario" >&2; exit 2 ;;
  esac
  anotar_referencias_iniciales
  echo "Preparado $escenario en $BASE · frase de prueba: «${FRASES[$escenario]}»"
}

# ---------------------------------------------------------------- comprobación

FALLOS=0
bien() { echo "  OK     $1"; }
mal() { echo "  FALLO  $1"; FALLOS=$((FALLOS + 1)); }
comprobar_que() { if eval "$2"; then bien "$1"; else mal "$1"; fi; }

ref_remota() { git -C "$BASE/remoto.git" rev-parse "$1"; }
en_ana() { git -C "$BASE/ana" "$@"; }
es_antecesor() { git -C "$1" merge-base --is-ancestor "$2" "$3" 2> /dev/null; }

main_intacta() { comprobar_que "main no ha recibido subidas directas" '[ "$(ref_remota main)" = "$(cat "$BASE/.main-inicial")" ]'; }
en_borrador_de_ana() { comprobar_que "Ana está en su borrador" '[ "$(en_ana branch --show-current)" = borrador-ana ]'; }
sin_fusion_a_medias() { ! en_ana rev-parse -q --verify MERGE_HEAD > /dev/null; }

comprobar() {
  local escenario="$1"
  echo "Comprobando $escenario en $BASE"
  case "$escenario" in
    S0)
      local intrusa="$BASE/intrusa"
      git clone -q "$BASE/remoto.git" "$intrusa"
      configurar_identidad "$intrusa" "Intrusa" "intrusa@example.invalid"
      echo "<!-- cambio directo -->" >> "$intrusa/biologia/index.html"
      git -C "$intrusa" commit -q -am "Intenta saltarse la protección"
      comprobar_que "GitHub simulado rechaza subir directamente a main" '! git -C "$intrusa" push -q origin HEAD:main 2> /dev/null'
      main_intacta
      comprobar_que "GitHub simulado acepta subir a un borrador" 'git -C "$intrusa" push -q origin HEAD:borrador-intrusa 2> /dev/null'
      ;;
    S1)
      main_intacta; en_borrador_de_ana
      comprobar_que "no hay cambios sin guardar" '[ -z "$(en_ana status --porcelain)" ]'
      comprobar_que "el borrador sigue igual que en GitHub" '[ "$(en_ana rev-parse HEAD)" = "$(ref_remota borrador-ana)" ]'
      ;;
    S2)
      main_intacta; en_borrador_de_ana
      comprobar_que "el borrador incluye lo publicado por Berta" 'es_antecesor "$BASE/ana" "$(ref_remota main)" HEAD'
      comprobar_que "la web de Química está en la carpeta de Ana" '[ -f "$BASE/ana/quimica/index.html" ]'
      ;;
    S3)
      main_intacta
      comprobar_que "no ha subido nada sin confirmación" '[ "$(ref_remota borrador-ana)" = "$(cat "$BASE/.borrador-ana-inicial")" ]'
      if sin_fusion_a_medias; then
        local pagina="$BASE/ana/biologia/index.html"
        comprobar_que "sin marcas de conflicto" '! grep -qE "^(<<<<<<<|=======|>>>>>>>)" "$pagina"'
        comprobar_que "conserva la definición de Ana" 'grep -q "estructural y funcional" "$pagina"'
        comprobar_que "conserva el añadido de Berta" 'grep -q "Robert Hooke" "$pagina"'
        comprobar_que "la fusión con lo publicado está hecha" 'es_antecesor "$BASE/ana" "$(ref_remota main)" HEAD'
      else
        echo "  AVISO  se detuvo con la fusión a medias (válido si preguntó antes de aplicar la solución)"
      fi
      comprobar_que "el commit de Ana sigue en su borrador" 'es_antecesor "$BASE/ana" "$(cat "$BASE/.borrador-ana-inicial")" HEAD'
      ;;
    S4)
      main_intacta
      comprobar_que "la actividad sin guardar no se ha perdido" \
        'grep -q "dibuja una célula" "$BASE/ana/biologia/index.html" || en_ana --no-pager log -p | grep -q "dibuja una célula"'
      if es_antecesor "$BASE/ana" "$(ref_remota main)" HEAD; then
        echo "  AVISO  trajo lo publicado: correcto solo si la docente aceptó antes guardar sus cambios"
      fi
      ;;
    S5)
      main_intacta; en_borrador_de_ana
      local commit_actividad
      commit_actividad="$(en_ana log --all --format=%H --grep='Añade una actividad' -n 1 || true)"
      comprobar_que "el commit hecho en main está en el borrador" '[ -n "$commit_actividad" ] && es_antecesor "$BASE/ana" "$commit_actividad" borrador-ana'
      comprobar_que "main local vuelve a ser lo publicado" '[ "$(en_ana rev-parse main)" = "$(ref_remota main)" ]'
      ;;
    S6)
      main_intacta
      comprobar_que "sin force push: el commit del portátil sigue en GitHub" 'es_antecesor "$BASE/remoto.git" "$(cat "$BASE/.commit-portatil")" borrador-ana'
      comprobar_que "la actividad nueva está guardada en GitHub" 'git -C "$BASE/remoto.git" show borrador-ana:biologia/index.html | grep -q "dibuja una célula"'
      comprobar_que "no quedan cambios sin guardar" '[ -z "$(en_ana status --porcelain)" ]'
      ;;
    S7)
      local proyecto="$BASE/proyecto"
      comprobar_que "AGENTS.md conserva su contenido" 'head -1 "$proyecto/AGENTS.md" | grep -qx "# Mi proyecto" && grep -q "Usa siempre un tono formal" "$proyecto/AGENTS.md"'
      comprobar_que "un solo bloque del kit (idempotente)" '[ "$(grep -c "kit:inicio" "$proyecto/AGENTS.md")" = 1 ] && [ "$(grep -c "kit:fin" "$proyecto/AGENTS.md")" = 1 ]'
      comprobar_que "el bloque es el de la plantilla" 'diff -q <(sed -n "/kit:inicio/,/kit:fin/p" "$proyecto/AGENTS.md") "$PLANTILLAS/bloque-kit.md" > /dev/null'
      comprobar_que ".gitattributes con finales de línea, una vez" '[ "$(grep -cx "\* text=auto eol=lf" "$proyecto/.gitattributes")" = 1 ]'
      comprobar_que ".gitignore conserva lo suyo y añade _site/ una vez" 'grep -qx "borradores/" "$proyecto/.gitignore" && [ "$(grep -cx "_site/" "$proyecto/.gitignore")" = 1 ]'
      comprobar_que "workflow de publicación instalado" 'cmp -s "$PLANTILLAS/publicar-web.yml" "$proyecto/.github/workflows/publicar-web.yml"'
      comprobar_que "script de la portada instalado" 'cmp -s "$PLANTILLAS/montar_web.py" "$proyecto/.github/scripts/montar_web.py"'
      comprobar_que "plantilla de pull request instalada" '[ -f "$proyecto/.github/pull_request_template.md" ]'
      comprobar_que "la skill propia no se ha tocado" 'cmp -s "$BASE/.mi-skill-original" "$proyecto/.agents/skills/mi-skill/SKILL.md"'
      local skill
      for skill in configurar-proyecto empezar-sesion guardar publicar resolver-conflictos crear-web invitar; do
        comprobar_que "skill $skill instalada" '[ -f "$proyecto/.agents/skills/$skill/SKILL.md" ]'
      done
      comprobar_que "no hay cambios sin guardar" '[ -z "$(git -C "$proyecto" status --porcelain)" ]'
      ;;
    S9)
      main_intacta
      local carpeta
      carpeta="$(find "$BASE/ana" -mindepth 2 -maxdepth 2 -name index.html -newer "$BASE/.main-inicial" -printf '%h\n' | xargs -r -n1 basename | head -1)"
      comprobar_que "hay una carpeta nueva con index.html" '[ -n "$carpeta" ]'
      comprobar_que "el nombre de la carpeta sirve para una dirección web" '[[ "$carpeta" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]]'
      comprobar_que "la web tiene título y descripción" 'grep -q "<title>[^<]" "$BASE/ana/$carpeta/index.html" && grep -q "name=\"description\" content=\"[^\"]" "$BASE/ana/$carpeta/index.html"'
      python3 "$PLANTILLAS/montar_web.py" "$BASE/ana" > /dev/null
      comprobar_que "la portada enlaza la web nueva y la de Biología" 'grep -q "href=\"$carpeta/\"" "$BASE/ana/_site/index.html" && grep -q "href=\"biologia/\"" "$BASE/ana/_site/index.html"'
      ;;
    S10)
      comprobar_que "el archivo escrito con finales de Windows se guarda con LF" '! en_ana cat-file -p HEAD:fisica/index.html | grep -q $'"'"'\r'"'"''
      ;;
    S11)
      main_intacta
      comprobar_que "las notas no se han guardado" '! en_ana cat-file -e HEAD:biologia/notas-alumnado.csv 2> /dev/null'
      comprobar_que "las notas no han llegado a GitHub" '! git -C "$BASE/remoto.git" cat-file -e borrador-ana:biologia/notas-alumnado.csv 2> /dev/null'
      comprobar_que "el archivo sigue en el ordenador (no se ha borrado sin preguntar)" '[ -f "$BASE/ana/biologia/notas-alumnado.csv" ]'
      ;;
    S12)
      main_intacta; en_borrador_de_ana
      comprobar_que "main local no ha recibido commits" '[ "$(en_ana rev-parse main)" = "$(cat "$BASE/.main-inicial")" ]'
      comprobar_que "la actividad está guardada en GitHub, en el borrador" 'git -C "$BASE/remoto.git" show borrador-ana:biologia/index.html | grep -q "dibuja una célula"'
      comprobar_que "no quedan cambios sin guardar" '[ -z "$(en_ana status --porcelain)" ]'
      ;;
    S13)
      main_intacta; en_borrador_de_ana
      comprobar_que "la actividad está guardada en este ordenador" 'en_ana show HEAD:biologia/index.html | grep -q "dibuja una célula"'
      comprobar_que "no quedan cambios sin guardar" '[ -z "$(en_ana status --porcelain)" ]'
      comprobar_que "no ha cambiado a dónde apunta origin" '[ "$(en_ana remote get-url origin)" = "$BASE/sin-conexion.git" ]'
      ;;
    *) echo "Escenario desconocido: $escenario" >&2; exit 2 ;;
  esac
  if [ "$FALLOS" -eq 0 ]; then echo "Resultado: OK"; else echo "Resultado: $FALLOS fallo(s)"; exit 1; fi
}

case "${1:-}" in
  preparar) BASE="$(realpath -m "$3")"; preparar "$2" ;;
  comprobar) BASE="$(realpath -m "$3")"; comprobar "$2" ;;
  lista) for escenario in "${!FRASES[@]}"; do echo "$escenario: ${FRASES[$escenario]}"; done | sort -V ;;
  *) sed -n '2,13p' "$0"; exit 2 ;;
esac

"""Monta en `_site/` la web que GitHub Pages publica.

Copia las carpetas y archivos visibles de la raíz del proyecto (no los ocultos ni los `.md`
de la raíz, como AGENTS.md o README.md). Si la raíz no tiene su propio `index.html`, genera
una portada que enlaza cada web: cada carpeta de la raíz que contiene un `index.html`, con su
`<title>` y su `<meta name="description">`.

Forma parte del kit github-friendly y se reescribe al actualizar el kit.
Uso: python3 montar_web.py [raíz del proyecto]
"""

import html
import os
import shutil
import sys
import unicodedata
from dataclasses import dataclass
from html.parser import HTMLParser
from pathlib import Path
from urllib.parse import quote

NOMBRE_SALIDA = "_site"
CARPETAS_EXCLUIDAS = {NOMBRE_SALIDA, "node_modules"}


@dataclass(frozen=True)
class Web:
    carpeta: str
    titulo: str
    descripcion: str


class LectorCabecera(HTMLParser):
    """Lee el primer <title> y la <meta name="description"> de una página."""

    def __init__(self) -> None:
        super().__init__(convert_charrefs=True)
        self.titulo = ""
        self.descripcion = ""
        self._dentro_del_titulo = False
        self._titulo_leido = False

    def handle_starttag(self, etiqueta: str, atributos: list[tuple[str, str | None]]) -> None:
        if etiqueta == "title" and not self._titulo_leido:
            self._dentro_del_titulo = True
        elif etiqueta == "meta" and not self.descripcion:
            valores = {nombre.lower(): valor or "" for nombre, valor in atributos}
            if valores.get("name", "").lower() == "description":
                self.descripcion = valores.get("content", "")

    def handle_endtag(self, etiqueta: str) -> None:
        if etiqueta == "title" and self._dentro_del_titulo:
            self._dentro_del_titulo = False
            self._titulo_leido = True

    def handle_data(self, datos: str) -> None:
        if self._dentro_del_titulo:
            self.titulo += datos


def es_oculto(nombre: str) -> bool:
    return nombre.startswith(".")


def leer_web(carpeta: Path) -> Web:
    lector = LectorCabecera()
    lector.feed((carpeta / "index.html").read_text(encoding="utf-8", errors="replace"))
    titulo = " ".join(lector.titulo.split()) or carpeta.name
    descripcion = " ".join(lector.descripcion.split())
    return Web(carpeta=carpeta.name, titulo=titulo, descripcion=descripcion)


def clave_de_orden(texto: str) -> str:
    """Ordena sin tener en cuenta mayúsculas ni tildes ("Ámbito" junto a "ambiente")."""
    sin_tildes = unicodedata.normalize("NFKD", texto)
    return "".join(letra for letra in sin_tildes if not unicodedata.combining(letra)).casefold()


def buscar_webs(raiz: Path) -> list[Web]:
    webs = [
        leer_web(entrada)
        for entrada in raiz.iterdir()
        if entrada.is_dir()
        and not es_oculto(entrada.name)
        and entrada.name not in CARPETAS_EXCLUIDAS
        and (entrada / "index.html").is_file()
    ]
    return sorted(webs, key=lambda web: clave_de_orden(web.titulo))


def nombre_del_sitio(raiz: Path) -> str:
    repositorio = os.environ.get("GITHUB_REPOSITORY", "").rpartition("/")[2] or raiz.resolve().name
    nombre = repositorio.replace("-", " ").replace("_", " ").strip()
    return nombre[:1].upper() + nombre[1:]


def generar_portada(nombre: str, webs: list[Web]) -> str:
    if webs:
        elementos = "\n".join(
            f'      <li><a href="{quote(web.carpeta)}/">{html.escape(web.titulo)}</a>'
            + (f"<p>{html.escape(web.descripcion)}</p>" if web.descripcion else "")
            + "</li>"
            for web in webs
        )
        contenido = f"    <ul>\n{elementos}\n    </ul>"
    else:
        contenido = "    <p>Todavía no hay ninguna web publicada.</p>"
    return f"""<!doctype html>
<html lang="es">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>{html.escape(nombre)}</title>
  <style>
    body {{ font-family: system-ui, sans-serif; max-width: 48rem; margin: 2rem auto; padding: 0 1rem; line-height: 1.6; }}
    ul {{ list-style: none; padding: 0; }}
    li {{ margin-bottom: 1.25rem; }}
    li a {{ font-size: 1.2rem; font-weight: 600; }}
    li p {{ margin: 0.25rem 0 0; }}
  </style>
</head>
<body>
  <main>
    <h1>{html.escape(nombre)}</h1>
{contenido}
  </main>
</body>
</html>
"""


def montar(raiz: Path) -> Path:
    salida = raiz / NOMBRE_SALIDA
    if salida.exists():
        shutil.rmtree(salida)
    salida.mkdir()
    for entrada in raiz.iterdir():
        if es_oculto(entrada.name) or entrada.name in CARPETAS_EXCLUIDAS:
            continue
        if entrada.is_dir():
            shutil.copytree(entrada, salida / entrada.name, ignore=shutil.ignore_patterns(".*"))
        elif entrada.suffix.lower() != ".md":
            shutil.copy2(entrada, salida / entrada.name)
    if not (raiz / "index.html").is_file():
        webs = buscar_webs(raiz)
        (salida / "index.html").write_text(generar_portada(nombre_del_sitio(raiz), webs), encoding="utf-8")
        print(f"Portada generada con {len(webs)} web(s).")
    else:
        print("El proyecto tiene su propia portada (index.html en la raíz): no se genera ninguna.")
    return salida


if __name__ == "__main__":
    montar(Path(sys.argv[1]) if len(sys.argv) > 1 else Path.cwd())

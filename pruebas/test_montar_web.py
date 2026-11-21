"""Pruebas del script que monta la web publicada y genera la portada.

Uso, desde la raíz del kit: python3 -m unittest discover -s pruebas
"""

import importlib.util
import sys
import tempfile
import unittest
from pathlib import Path

# Sin esto, Python deja un __pycache__ dentro de plantillas/ y gh skill install lo copiaría a los proyectos.
sys.dont_write_bytecode = True

RUTA_SCRIPT = Path(__file__).resolve().parents[1] / "skills/configurar-proyecto/plantillas/montar_web.py"
especificacion = importlib.util.spec_from_file_location("montar_web", RUTA_SCRIPT)
montar_web = importlib.util.module_from_spec(especificacion)
especificacion.loader.exec_module(montar_web)


def escribir(ruta: Path, texto: str) -> None:
    ruta.parent.mkdir(parents=True, exist_ok=True)
    ruta.write_text(texto, encoding="utf-8")


def pagina(titulo: str, descripcion: str | None = None) -> str:
    meta = f'<meta name="description" content="{descripcion}">' if descripcion is not None else ""
    return f"<!doctype html><html><head><title>{titulo}</title>{meta}</head><body></body></html>"


class PruebasMontarWeb(unittest.TestCase):
    def setUp(self) -> None:
        self.directorio_temporal = tempfile.TemporaryDirectory()
        self.raiz = Path(self.directorio_temporal.name) / "webs-departamento"
        self.raiz.mkdir()

    def tearDown(self) -> None:
        self.directorio_temporal.cleanup()

    def test_portada_lista_cada_web_ordenada_sin_tildes(self) -> None:
        escribir(self.raiz / "zoologia/index.html", pagina("Zoología", "Animales del entorno"))
        escribir(self.raiz / "atomos/index.html", pagina("Átomos", "Estructura de la materia"))
        escribir(self.raiz / "biologia/index.html", pagina("biología celular"))
        salida = montar_web.montar(self.raiz)
        portada = (salida / "index.html").read_text(encoding="utf-8")
        posiciones = [portada.index(titulo) for titulo in ("Átomos", "biología celular", "Zoología")]
        self.assertEqual(posiciones, sorted(posiciones))
        self.assertIn('<a href="atomos/">', portada)
        self.assertIn("<p>Animales del entorno</p>", portada)
        self.assertIn("<title>Webs departamento</title>", portada)

    def test_portada_propia_en_la_raiz_se_respeta(self) -> None:
        escribir(self.raiz / "index.html", "<h1>Mi portada</h1>")
        escribir(self.raiz / "quimica/index.html", pagina("Química"))
        salida = montar_web.montar(self.raiz)
        self.assertEqual((salida / "index.html").read_text(encoding="utf-8"), "<h1>Mi portada</h1>")
        self.assertTrue((salida / "quimica/index.html").is_file())

    def test_no_publica_ocultos_ni_md_de_la_raiz(self) -> None:
        escribir(self.raiz / "AGENTS.md", "reglas")
        escribir(self.raiz / "README.md", "léeme")
        escribir(self.raiz / ".agents/skills/guardar/SKILL.md", "skill")
        escribir(self.raiz / ".github/workflows/publicar-web.yml", "workflow")
        escribir(self.raiz / "fisica/index.html", pagina("Física"))
        escribir(self.raiz / "fisica/.borrador.txt", "oculto")
        escribir(self.raiz / "fisica/apuntes.md", "apuntes dentro de una web")
        escribir(self.raiz / "favicon.ico", "icono")
        salida = montar_web.montar(self.raiz)
        publicados = {ruta.relative_to(salida).as_posix() for ruta in salida.rglob("*") if ruta.is_file()}
        self.assertEqual(publicados, {"index.html", "favicon.ico", "fisica/index.html", "fisica/apuntes.md"})

    def test_carpeta_sin_index_se_copia_pero_no_aparece_en_la_portada(self) -> None:
        escribir(self.raiz / "comun/estilos.css", "body {}")
        escribir(self.raiz / "historia/index.html", pagina("Historia"))
        salida = montar_web.montar(self.raiz)
        portada = (salida / "index.html").read_text(encoding="utf-8")
        self.assertTrue((salida / "comun/estilos.css").is_file())
        self.assertNotIn("comun/", portada)
        self.assertIn('<a href="historia/">', portada)

    def test_escapa_textos_y_usa_la_carpeta_si_no_hay_titulo(self) -> None:
        escribir(self.raiz / "musica/index.html", pagina("Do &amp; &lt;Re&gt;", "Notas &quot;mi&quot; fa"))
        escribir(self.raiz / "sin-titulo/index.html", "<html><body>vacía</body></html>")
        portada = (montar_web.montar(self.raiz) / "index.html").read_text(encoding="utf-8")
        self.assertIn("Do &amp; &lt;Re&gt;", portada)
        self.assertIn("Notas &quot;mi&quot; fa", portada)
        self.assertIn('<a href="sin-titulo/">sin-titulo</a>', portada)

    def test_solo_cuenta_el_primer_title(self) -> None:
        escribir(
            self.raiz / "arte/index.html",
            "<html><head><title>Arte</title></head><body><svg><title>Icono</title></svg></body></html>",
        )
        portada = (montar_web.montar(self.raiz) / "index.html").read_text(encoding="utf-8")
        self.assertIn(">Arte</a>", portada)
        self.assertNotIn("Icono", portada)

    def test_sin_webs_avisa_y_volver_a_montar_no_acumula(self) -> None:
        montar_web.montar(self.raiz)
        salida = montar_web.montar(self.raiz)
        self.assertIn("Todavía no hay ninguna web publicada.", (salida / "index.html").read_text(encoding="utf-8"))
        self.assertFalse((salida / "_site").exists())


if __name__ == "__main__":
    unittest.main()

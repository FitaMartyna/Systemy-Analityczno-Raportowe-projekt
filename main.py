import os
import sys
from dataclasses import dataclass
from typing import Any, Dict, List, Optional, Tuple

from dotenv import load_dotenv # type: ignore
from supabase import create_client, Client # type: ignore

from PySide6.QtCore import Qt # type: ignore
from PySide6.QtGui import QIntValidator, QDoubleValidator # type: ignore
from PySide6.QtWidgets import ( # type: ignore
    QApplication,
    QComboBox,
    QFormLayout,
    QLineEdit,
    QMainWindow,
    QMessageBox,
    QPushButton,
    QScrollArea,
    QToolBar,
    QWidget,
    QVBoxLayout,
    QStatusBar,
)


# -----------------------------
# Config: forms -> rpc + fields
# -----------------------------
@dataclass
class FieldSpec:
    key: str
    label: str
    kind: str  # "int" | "float" | "text"
    required: bool = True
    placeholder: str = ""


@dataclass
class FormSpec:
    title: str
    rpc: str
    fields: List[FieldSpec]


FORMS: List[FormSpec] = [
    # 1) Aktywa obrotowe
    FormSpec(
        title="F_Aktywa_Obrotowe",
        rpc="insert_f_aktywa_obrotowe",
        fields=[
            FieldSpec("p_kwota", "Kwota (FLOAT)", "float"),
            FieldSpec("p_wyszczegolnienie", "Wyszczególnienie", "text"),
            FieldSpec("p_rok", "Rok (INT)", "int"),
            FieldSpec("p_scenariusz", "Scenariusz", "text"),
        ],
    ),
    # 2) Aktywa trwałe
    FormSpec(
        title="F_Aktywa_Trwale",
        rpc="insert_f_aktywa_trwale",
        fields=[
            FieldSpec("p_kwota", "Kwota (FLOAT)", "float"),
            FieldSpec("p_wyszczegolnienie", "Wyszczególnienie", "text"),
            FieldSpec("p_rok", "Rok (INT)", "int"),
            FieldSpec("p_scenariusz", "Scenariusz", "text"),
        ],
    ),
    # 3) Kapitał obcy
    FormSpec(
        title="F_Kapital_Obcy",
        rpc="insert_f_kapital_obcy",
        fields=[
            FieldSpec("p_kwota", "Kwota (FLOAT)", "float"),
            FieldSpec("p_wyszczegolnienie", "Wyszczególnienie", "text"),
            FieldSpec("p_rok", "Rok (INT)", "int"),
            FieldSpec("p_scenariusz", "Scenariusz", "text"),
        ],
    ),
    # 4) Kapitał własny
    FormSpec(
        title="F_Kapital_Wlasny",
        rpc="insert_f_kapital_wlasny",
        fields=[
            FieldSpec("p_kwota", "Kwota (FLOAT)", "float"),
            FieldSpec("p_wyszczegolnienie", "Wyszczególnienie", "text"),
            FieldSpec("p_rok", "Rok (INT)", "int"),
            FieldSpec("p_scenariusz", "Scenariusz", "text"),
        ],
    ),
    # 5) Koszty materiałów 
    FormSpec(
        title="F_Koszty_Materialow",
        rpc="insert_f_koszty_materialow",
        fields=[
            FieldSpec("p_koszt_jednostkowy", "Koszt jednostkowy (FLOAT)", "float"),
            FieldSpec("p_material_nazwa", "Nazwa materiału", "text"),
            FieldSpec("p_material_jednostka", "Jednostka materiału", "text"),
            FieldSpec("p_rok", "Rok (INT)", "int"),
            FieldSpec("p_scenariusz", "Scenariusz", "text"),
        ],
    ),
    # 6) Koszty sprzedaży
    FormSpec(
        title="F_Koszty_Sprzedazy",
        rpc="insert_f_koszty_sprzedazy",
        fields=[
            FieldSpec("p_kwota", "Kwota (FLOAT)", "float"),
            FieldSpec("p_rodzaj_kosztu_nazwa", "Rodzaj kosztu", "text"),
            FieldSpec("p_rok", "Rok (INT)", "int"),
            FieldSpec("p_scenariusz", "Scenariusz", "text"),
        ],
    ),
    # 7) Koszty zarządu 
    FormSpec(
        title="F_Koszty_Zarzadu",
        rpc="insert_f_koszty_zarzadu",
        fields=[
            FieldSpec("p_kwota", "Kwota (FLOAT)", "float"),
            FieldSpec("p_rodzaj_kosztu_nazwa", "Rodzaj kosztu", "text"),
            FieldSpec("p_rok", "Rok (INT)", "int"),
            FieldSpec("p_scenariusz", "Scenariusz", "text"),
        ],
    ),
    # 8) Kredyt
    FormSpec(
        title="F_Kredyt",
        rpc="insert_f_kredyt",
        fields=[
            FieldSpec("p_kwota", "Kwota (FLOAT)", "float"),
            FieldSpec("p_wyszczegolnienie", "Rodzaj kredytu (wyszczególnienie)", "text"),
            FieldSpec("p_rok", "Rok (INT)", "int"),
            FieldSpec("p_nazwa_scenariusza", "Scenariusz", "text"),
        ],
    ),
    # 9) Narzut kosztów zmiennych wydziałowych
    FormSpec(
        title="F_Narzut_Kosztow_Zmiennych_Wydzialowych",
        rpc="insert_f_narzut_kosztow_zmiennych_wydzialowych",
        fields=[
            FieldSpec("p_nazwa_linii", "Nazwa linii", "text"),
            FieldSpec("p_nazwa_koszt_wydzialowy_kontrolowany", "Nazwa kosztu kontrolowanego", "text"),
            FieldSpec("p_narzut", "Narzut (FLOAT)", "float"),
            FieldSpec("p_rok", "Rok (INT)", "int"),
            FieldSpec("p_nazwa_scenariusza", "Scenariusz", "text"),
        ],
    ),
    # 10) Normy zużycia materiałów
    FormSpec(
        title="F_Normy_Zuzycia_Materialow",
        rpc="insert_f_normy_zuzycia_materialow",
        fields=[
            FieldSpec("p_norma_zuzycia", "Norma zużycia (FLOAT)", "float"),
            FieldSpec("p_nazwa_produktu", "Nazwa produktu", "text"),
            FieldSpec("p_nazwa_linii", "Nazwa linii", "text"),
            FieldSpec("p_rok", "Rok (INT)", "int"),
            FieldSpec("p_nazwa_scenariusza", "Scenariusz", "text"),
            FieldSpec("p_nazwa_materialu", "Nazwa materiału", "text"),
            FieldSpec("p_jednostka_materialu", "Jednostka materiału", "text"),
        ],
    ),
    # 11) Planowana sprzedaż produktów
    FormSpec(
        title="F_Planowana_Sprzedaz_Produktow",
        rpc="insert_f_planowana_sprzedaz_produktow",
        fields=[
            FieldSpec("p_wielkosci_sprzedazy", "Wielkość sprzedaży (INT)", "int"),
            FieldSpec("p_cena_sprzedazy", "Cena sprzedaży (FLOAT)", "float"),
            FieldSpec("p_nazwa_produktu", "Nazwa produktu", "text"),
            FieldSpec("p_nazwa_linii", "Nazwa linii", "text"),
            FieldSpec("p_rok", "Rok (INT)", "int"),
            FieldSpec("p_nazwa_scenariusza", "Scenariusz", "text"),
        ],
    ),
    # 12) Planowane zapasy materiałów
    FormSpec(
        title="F_Planowane_Zapasy_Materialow",
        rpc="insert_f_planowane_zapasy_materialow",
        fields=[
            FieldSpec("p_zapas_poczatkowy", "Zapas początkowy (FLOAT)", "float"),
            FieldSpec("p_zapas_koncowy", "Zapas końcowy (FLOAT)", "float"),
            FieldSpec("p_nazwa_materialu", "Nazwa materiału", "text"),
            FieldSpec("p_jednostka_materialu", "Jednostka materiału", "text"),
            FieldSpec("p_rok", "Rok (INT)", "int"),
            FieldSpec("p_nazwa_scenariusza", "Scenariusz", "text"),
        ],
    ),
    # 13) Planowane zapasy produktów gotowych
    FormSpec(
        title="F_Planowane_Zapasy_Produktow_Gotowych",
        rpc="insert_f_planowane_zapasy_produktow_gotowych",
        fields=[
            FieldSpec("p_zapas_poczatkowy", "Zapas początkowy (INT)", "int"),
            FieldSpec("p_zapas_koncowy", "Zapas końcowy (INT)", "int"),
            FieldSpec("p_nazwa_produktu", "Nazwa produktu", "text"),
            FieldSpec("p_nazwa_linii", "Nazwa linii", "text"),
            FieldSpec("p_rok", "Rok (INT)", "int"),
            FieldSpec("p_nazwa_scenariusza", "Scenariusz", "text"),
        ],
    ),
    # 14) Prowizja
    FormSpec(
        title="F_Prowizja",
        rpc="insert_f_prowizja",
        fields=[
            FieldSpec("p_prowizja_za_sztuke", "Prowizja za sztukę (FLOAT)", "float"),
            FieldSpec("p_nazwa_produktu", "Nazwa produktu", "text"),
            FieldSpec("p_nazwa_linii", "Nazwa linii", "text"),
            FieldSpec("p_rok", "Rok (INT)", "int"),
            FieldSpec("p_nazwa_scenariusza", "Scenariusz", "text"),
        ],
    ),
    # 15) Robocizna
    FormSpec(
        title="F_Robocizna",
        rpc="insert_f_robocizna",
        fields=[
            FieldSpec("p_roboczna_potrzeba", "Robocizna potrzebna (FLOAT)", "float"),
            FieldSpec("p_roboczna_frh", "Robocizna 1rh (INT)", "int"),
            FieldSpec("p_nazwa_produktu", "Nazwa produktu", "text"),
            FieldSpec("p_nazwa_linii", "Nazwa linii", "text"),
            FieldSpec("p_rok", "Rok (INT)", "int"),
            FieldSpec("p_nazwa_scenariusza", "Scenariusz", "text"),
        ],
    ),
    # 16) Stałe koszty wydziału produkcyjnego
    FormSpec(
        title="F_Stale_Koszty_Wydzialu_Produkcyjnego",
        rpc="insert_f_stale_koszty_wydzialu_produkcyjnego",
        fields=[
            FieldSpec("p_koszt", "Koszt (FLOAT)", "float"),
            FieldSpec("p_nazwa", "Nazwa kosztu niekontrolowanego", "text"),
            FieldSpec("p_rok", "Rok (INT)", "int"),
            FieldSpec("p_nazwa_scenariusza", "Scenariusz", "text"),
        ],
    ),
]


# -----------------------------
# UI
# -----------------------------
class MainWindow(QMainWindow):
    def __init__(self, supabase: Client) -> None:
        super().__init__()
        self.supabase = supabase
        self.setWindowTitle("Supabase ETL – formularze faktów (RPC)")

        self._current_form: Optional[FormSpec] = None
        self._inputs: Dict[str, QLineEdit] = {}

        # Toolbar
        tb = QToolBar("Formularze")
        tb.setMovable(False)
        self.addToolBar(tb)

        self.form_combo = QComboBox()
        for f in FORMS:
            self.form_combo.addItem(f.title)
        self.form_combo.currentIndexChanged.connect(self._on_form_changed)
        tb.addWidget(self.form_combo)

        # Central
        central = QWidget()
        self.setCentralWidget(central)
        outer = QVBoxLayout(central)

        self.scroll = QScrollArea()
        self.scroll.setWidgetResizable(True)
        outer.addWidget(self.scroll)

        self.form_container = QWidget()
        self.form_layout = QFormLayout(self.form_container)
        self.form_layout.setLabelAlignment(Qt.AlignRight)
        self.scroll.setWidget(self.form_container)

        self.submit_btn = QPushButton("Wyślij (RPC)")
        self.submit_btn.clicked.connect(self._submit)
        outer.addWidget(self.submit_btn)

        self.setStatusBar(QStatusBar())
        self.statusBar().showMessage("Gotowe")

        # Init first form
        self._on_form_changed(0)

    def _on_form_changed(self, idx: int) -> None:
        self._current_form = FORMS[idx]
        self._rebuild_form(self._current_form)

    def _clear_layout(self) -> None:
        while self.form_layout.count():
            item = self.form_layout.takeAt(0)
            w = item.widget()
            if w:
                w.deleteLater()
        self._inputs.clear()

    def _make_input(self, spec: FieldSpec) -> QLineEdit:
        le = QLineEdit()
        le.setPlaceholderText(spec.placeholder)

        if spec.kind == "int":
            le.setValidator(QIntValidator())
        elif spec.kind == "float":
            dv = QDoubleValidator()
            dv.setNotation(QDoubleValidator.StandardNotation)
            le.setValidator(dv)

        return le

    def _rebuild_form(self, form: FormSpec) -> None:
        self._clear_layout()
        for fs in form.fields:
            le = self._make_input(fs)
            self._inputs[fs.key] = le
            self.form_layout.addRow(fs.label, le)

        self.statusBar().showMessage(f"Wybrano: {form.title} → RPC: {form.rpc}")

    def _build_payload(self, form: FormSpec) -> Tuple[Optional[Dict[str, Any]], Optional[str]]:
        payload: Dict[str, Any] = {}

        for fs in form.fields:
            le = self._inputs[fs.key]
            raw = le.text().strip()

            if raw == "":
                return None, f"Pole nie może być puste: {fs.label}"

            if fs.kind == "int":
                try:
                    payload[fs.key] = int(raw)
                except ValueError:
                    return None, f"Niepoprawna liczba całkowita w polu: {fs.label}"

            elif fs.kind == "float":
                try:
                    payload[fs.key] = float(raw)
                except ValueError:
                    return None, f"Niepoprawna liczba (float) w polu: {fs.label}"

            else:  
                payload[fs.key] = raw

        return payload, None


    def _submit(self) -> None:
        if not self._current_form:
            return

        form = self._current_form
        payload, err = self._build_payload(form)
        if err:
            QMessageBox.warning(self, "Błąd walidacji", err)
            return

        assert payload is not None

        try:
            res = self.supabase.rpc(form.rpc, payload).execute()
            self.statusBar().showMessage("OK – RPC wykonane")
            QMessageBox.information(
                self,
                "Sukces",
                f"Wywołano: {form.rpc}\nPayload: {payload}\n\nZwrócone data: {getattr(res, 'data', None)}",
            )
        except Exception as e:
            self.statusBar().showMessage("Błąd – RPC nieudane")
            QMessageBox.critical(self, "Błąd RPC", str(e))


def main() -> int:
    load_dotenv()

    url = os.getenv("SUPABASE_URL")
    key = os.getenv("SUPABASE_KEY")

    if not url or not key:
        print("Brak SUPABASE_URL / SUPABASE_KEY w .env.")
        return 1

    supabase: Client = create_client(url, key)

    app = QApplication(sys.argv)
    w = MainWindow(supabase)
    w.resize(600, 650)
    w.show()
    return app.exec()


if __name__ == "__main__":
    raise SystemExit(main())

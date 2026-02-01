-- WARNING: This schema is for context only and is not meant to be run.
-- Table order and constraints may not be valid for execution.

CREATE TABLE public.D_Koszty_Wydzialowe_Kontrolowane (
  id_koszt_wydzialowy_kontrolowany bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  nazwa character varying,
  CONSTRAINT D_Koszty_Wydzialowe_Kontrolowane_pkey PRIMARY KEY (id_koszt_wydzialowy_kontrolowany)
);
CREATE TABLE public.D_Koszty_Wydzialowe_Niekontrolowane (
  id_koszt_wydzialowy_niekontrolowany bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  nazwa character varying UNIQUE,
  CONSTRAINT D_Koszty_Wydzialowe_Niekontrolowane_pkey PRIMARY KEY (id_koszt_wydzialowy_niekontrolowany)
);
CREATE TABLE public.D_Linia (
  id_linia bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  nazwa character varying UNIQUE,
  CONSTRAINT D_Linia_pkey PRIMARY KEY (id_linia)
);
CREATE TABLE public.D_Material (
  id_material bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  nazwa character varying UNIQUE,
  jednostka character varying,
  CONSTRAINT D_Material_pkey PRIMARY KEY (id_material)
);
CREATE TABLE public.D_Okres (
  id_okres bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  rok bigint UNIQUE,
  CONSTRAINT D_Okres_pkey PRIMARY KEY (id_okres)
);
CREATE TABLE public.D_Produkt (
  id_produkt bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  nazwa character varying UNIQUE,
  fk_id_linia bigint,
  CONSTRAINT D_Produkt_pkey PRIMARY KEY (id_produkt),
  CONSTRAINT D_Produkt_fk_id_linia_fkey FOREIGN KEY (fk_id_linia) REFERENCES public.D_Linia(id_linia)
);
CREATE TABLE public.D_Rodzaj_Aktywa_Obrotowe (
  id_rodzaj_aktywa_obrotowe bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  wyszczegolnienie character varying UNIQUE,
  CONSTRAINT D_Rodzaj_Aktywa_Obrotowe_pkey PRIMARY KEY (id_rodzaj_aktywa_obrotowe)
);
CREATE TABLE public.D_Rodzaj_Aktywa_Trwale (
  id_rodzaj_aktywa_trwale bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  wyszczegolnienie character varying UNIQUE,
  CONSTRAINT D_Rodzaj_Aktywa_Trwale_pkey PRIMARY KEY (id_rodzaj_aktywa_trwale)
);
CREATE TABLE public.D_Rodzaj_Kapital_Obcy (
  id_rodzaj_kapital_obcy bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  wyszczegolnienie character varying UNIQUE,
  CONSTRAINT D_Rodzaj_Kapital_Obcy_pkey PRIMARY KEY (id_rodzaj_kapital_obcy)
);
CREATE TABLE public.D_Rodzaj_Kapital_Wlasny (
  id_rodzaj_kapital_wlasny bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  wyszczegolnienie character varying UNIQUE,
  CONSTRAINT D_Rodzaj_Kapital_Wlasny_pkey PRIMARY KEY (id_rodzaj_kapital_wlasny)
);
CREATE TABLE public.D_Rodzaj_Kosztu (
  id_rodzaj_kosztu bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  nazwa character varying UNIQUE,
  CONSTRAINT D_Rodzaj_Kosztu_pkey PRIMARY KEY (id_rodzaj_kosztu)
);
CREATE TABLE public.D_Rodzaj_Kredyt (
  id_rodzaj_kredyt bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  wyszczegolnienie character varying UNIQUE,
  CONSTRAINT D_Rodzaj_Kredyt_pkey PRIMARY KEY (id_rodzaj_kredyt)
);
CREATE TABLE public.D_Scenariusz (
  id_scenariusz bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  nazwa character varying UNIQUE,
  CONSTRAINT D_Scenariusz_pkey PRIMARY KEY (id_scenariusz)
);
CREATE TABLE public.F_Aktywa_Obrotowe (
  id_fakt bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  kwota double precision,
  fk_id_okres bigint,
  fk_id_scenariusz bigint,
  fk_id_rodzaj_aktywa_obrotowe bigint,
  CONSTRAINT F_Aktywa_Obrotowe_pkey PRIMARY KEY (id_fakt),
  CONSTRAINT F_Aktywa_Obrotowe_fk_id_okres_fkey FOREIGN KEY (fk_id_okres) REFERENCES public.D_Okres(id_okres),
  CONSTRAINT F_Aktywa_Obrotowe_fk_id_scenariusz_fkey FOREIGN KEY (fk_id_scenariusz) REFERENCES public.D_Scenariusz(id_scenariusz),
  CONSTRAINT F_Aktywa_Obrotowe_fk_id_rodzaj_aktywa_obrotowe_fkey FOREIGN KEY (fk_id_rodzaj_aktywa_obrotowe) REFERENCES public.D_Rodzaj_Aktywa_Obrotowe(id_rodzaj_aktywa_obrotowe)
);
CREATE TABLE public.F_Aktywa_Trwale (
  id_fakt bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  kwota double precision,
  fk_id_okres bigint,
  fk_id_scenariusz bigint,
  fk_id_rodzaj_aktywa_trwale bigint,
  CONSTRAINT F_Aktywa_Trwale_pkey PRIMARY KEY (id_fakt),
  CONSTRAINT F_Aktywa_Trwale_fk_id_okres_fkey FOREIGN KEY (fk_id_okres) REFERENCES public.D_Okres(id_okres),
  CONSTRAINT F_Aktywa_Trwale_fk_id_scenariusz_fkey FOREIGN KEY (fk_id_scenariusz) REFERENCES public.D_Scenariusz(id_scenariusz),
  CONSTRAINT F_Aktywa_Trwale_fk_id_rodzaj_aktywa_trwale_fkey FOREIGN KEY (fk_id_rodzaj_aktywa_trwale) REFERENCES public.D_Rodzaj_Aktywa_Trwale(id_rodzaj_aktywa_trwale)
);
CREATE TABLE public.F_Kapital_Obcy (
  id_fakt bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  kwota double precision,
  fk_id_okres bigint,
  fk_id_scenariusz bigint,
  fk_id_rodzaj_kapital_obcy bigint,
  CONSTRAINT F_Kapital_Obcy_pkey PRIMARY KEY (id_fakt),
  CONSTRAINT F_Kapital_Obcy_fk_id_okres_fkey FOREIGN KEY (fk_id_okres) REFERENCES public.D_Okres(id_okres),
  CONSTRAINT F_Kapital_Obcy_fk_id_scenariusz_fkey FOREIGN KEY (fk_id_scenariusz) REFERENCES public.D_Scenariusz(id_scenariusz),
  CONSTRAINT F_Kapital_Obcy_fk_id_rodzaj_kapital_obcy_fkey FOREIGN KEY (fk_id_rodzaj_kapital_obcy) REFERENCES public.D_Rodzaj_Kapital_Obcy(id_rodzaj_kapital_obcy)
);
CREATE TABLE public.F_Kapital_Wlasny (
  id_fakt bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  kwota double precision,
  fk_id_okres bigint,
  fk_id_scenariusz bigint,
  fk_id_rodzaj_kapital_wlasny bigint,
  CONSTRAINT F_Kapital_Wlasny_pkey PRIMARY KEY (id_fakt),
  CONSTRAINT F_Kapital_Wlasny_fk_id_okres_fkey FOREIGN KEY (fk_id_okres) REFERENCES public.D_Okres(id_okres),
  CONSTRAINT F_Kapital_Wlasny_fk_id_scenarusz_fkey FOREIGN KEY (fk_id_scenariusz) REFERENCES public.D_Scenariusz(id_scenariusz),
  CONSTRAINT F_Kapital_Wlasny_fk_id_rodzaj_kapital_wlasny_fkey FOREIGN KEY (fk_id_rodzaj_kapital_wlasny) REFERENCES public.D_Rodzaj_Kapital_Wlasny(id_rodzaj_kapital_wlasny)
);
CREATE TABLE public.F_Koszty_Materialow (
  id_fakt bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  koszt_jednostkowy double precision,
  fk_id_material bigint,
  fk_id_okres bigint,
  fk_id_scenariusz bigint,
  CONSTRAINT F_Koszty_Materialow_pkey PRIMARY KEY (id_fakt),
  CONSTRAINT F_Koszty_Materialow_I_Robocizny_Bezposredni_fk_id_material_fkey FOREIGN KEY (fk_id_material) REFERENCES public.D_Material(id_material),
  CONSTRAINT F_Koszty_Materialow_I_Robocizny_Bezposredniej_fk_id_okres_fkey FOREIGN KEY (fk_id_okres) REFERENCES public.D_Okres(id_okres),
  CONSTRAINT F_Koszty_Materialow_I_Robocizny_Bezposred_fk_id_scenariusz_fkey FOREIGN KEY (fk_id_scenariusz) REFERENCES public.D_Scenariusz(id_scenariusz)
);
CREATE TABLE public.F_Koszty_Sprzedazy (
  id_fakt bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  kwota double precision,
  fk_id_rodzaj_kosztu bigint,
  fk_id_okres bigint,
  fk_id_scenariusz bigint,
  CONSTRAINT F_Koszty_Sprzedazy_pkey PRIMARY KEY (id_fakt),
  CONSTRAINT F_Koszty_Sprzedazy_fk_id_okres_fkey FOREIGN KEY (fk_id_okres) REFERENCES public.D_Okres(id_okres),
  CONSTRAINT F_Koszty_Sprzedazy_fk_id_rodzaj_kosztu_fkey FOREIGN KEY (fk_id_rodzaj_kosztu) REFERENCES public.D_Rodzaj_Kosztu(id_rodzaj_kosztu),
  CONSTRAINT F_Koszty_Sprzedazy_fk_id_scenariusz_fkey FOREIGN KEY (fk_id_scenariusz) REFERENCES public.D_Scenariusz(id_scenariusz)
);
CREATE TABLE public.F_Koszty_Zarzadu (
  id_fakt bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  kwota double precision,
  fk_id_rodzaj_kosztu bigint,
  fk_id_okres bigint,
  fk_id_scenariusz bigint,
  CONSTRAINT F_Koszty_Zarzadu_pkey PRIMARY KEY (id_fakt),
  CONSTRAINT F_Koszty_Zarzadu_fk_id_okres_fkey FOREIGN KEY (fk_id_okres) REFERENCES public.D_Okres(id_okres),
  CONSTRAINT F_Koszty_Zarzadu_fk_id_scenariusz_fkey FOREIGN KEY (fk_id_scenariusz) REFERENCES public.D_Scenariusz(id_scenariusz),
  CONSTRAINT F_Koszty_Zarzadu_fk_id_rodzaj_kosztu_fkey FOREIGN KEY (fk_id_rodzaj_kosztu) REFERENCES public.D_Rodzaj_Kosztu(id_rodzaj_kosztu)
);
CREATE TABLE public.F_Kredyt (
  id_fakt bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  kwota double precision,
  fk_id_okres bigint,
  fk_id_scenariusz bigint,
  fk_id_rodzaj_kredyt bigint,
  CONSTRAINT F_Kredyt_pkey PRIMARY KEY (id_fakt),
  CONSTRAINT F_Kredyt_fk_id_okres_fkey FOREIGN KEY (fk_id_okres) REFERENCES public.D_Okres(id_okres),
  CONSTRAINT F_Kredyt_fk_id_scenariusz_fkey FOREIGN KEY (fk_id_scenariusz) REFERENCES public.D_Scenariusz(id_scenariusz),
  CONSTRAINT F_Kredyt_fk_id_rodzaj_kredyt_fkey FOREIGN KEY (fk_id_rodzaj_kredyt) REFERENCES public.D_Rodzaj_Kredyt(id_rodzaj_kredyt)
);
CREATE TABLE public.F_Narzut_Kosztow_Zmiennych_Wydzialowych (
  id_fakt bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  narzut double precision,
  fk_id_linia bigint,
  fk_id_koszt_wydzialowy_kontrolowany bigint,
  fk_id_okres bigint,
  fk_id_scenariusz bigint,
  CONSTRAINT F_Narzut_Kosztow_Zmiennych_Wydzialowych_pkey PRIMARY KEY (id_fakt),
  CONSTRAINT F_Narzut_Kosztow_Zmiennych_Wy_fk_id_koszt_wydzialowy_kontr_fkey FOREIGN KEY (fk_id_koszt_wydzialowy_kontrolowany) REFERENCES public.D_Koszty_Wydzialowe_Kontrolowane(id_koszt_wydzialowy_kontrolowany),
  CONSTRAINT F_Narzut_Kosztow_Zmiennych_Wydzialowych_fk_id_linia_fkey FOREIGN KEY (fk_id_linia) REFERENCES public.D_Linia(id_linia),
  CONSTRAINT F_Narzut_Kosztow_Zmiennych_Wydzialowych_fk_id_okres_fkey FOREIGN KEY (fk_id_okres) REFERENCES public.D_Okres(id_okres),
  CONSTRAINT F_Narzut_Kosztow_Zmiennych_Wydzialowych_fk_id_scenariusz_fkey FOREIGN KEY (fk_id_scenariusz) REFERENCES public.D_Scenariusz(id_scenariusz)
);
CREATE TABLE public.F_Normy_Zuzycia_Materialow (
  id_fakt bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  norma_zuzycia double precision,
  fk_id_produkt bigint,
  fk_id_material bigint,
  fk_id_okres bigint,
  fk_id_scenariusz bigint,
  CONSTRAINT F_Normy_Zuzycia_Materialow_pkey PRIMARY KEY (id_fakt),
  CONSTRAINT F_Normy_Zuzycia_Materialow_fk_id_produkt_fkey FOREIGN KEY (fk_id_produkt) REFERENCES public.D_Produkt(id_produkt),
  CONSTRAINT F_Normy_Zuzycia_Materialow_fk_id_material_fkey FOREIGN KEY (fk_id_material) REFERENCES public.D_Material(id_material),
  CONSTRAINT F_Normy_Zuzycia_Materialow_fk_id_okres_fkey FOREIGN KEY (fk_id_okres) REFERENCES public.D_Okres(id_okres),
  CONSTRAINT F_Normy_Zuzycia_Materialow_fk_id_scenariusz_fkey FOREIGN KEY (fk_id_scenariusz) REFERENCES public.D_Scenariusz(id_scenariusz)
);
CREATE TABLE public.F_Planowana_Sprzedaz_Produktow (
  id_fakt bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  wielkosc_sprzedazy bigint,
  cena_sprzedazy double precision,
  fk_id_produkt bigint,
  fk_id_okres bigint,
  fk_id_scenariusz bigint,
  CONSTRAINT F_Planowana_Sprzedaz_Produktow_pkey PRIMARY KEY (id_fakt),
  CONSTRAINT F_Planowana_Sprzedaz_Produktow_fk_id_okres_fkey FOREIGN KEY (fk_id_okres) REFERENCES public.D_Okres(id_okres),
  CONSTRAINT F_Planowana_Sprzedaz_Produktow_fk_id_produkt_fkey FOREIGN KEY (fk_id_produkt) REFERENCES public.D_Produkt(id_produkt),
  CONSTRAINT F_Planowana_Sprzedaz_Produktow_fk_id_scenariusz_fkey FOREIGN KEY (fk_id_scenariusz) REFERENCES public.D_Scenariusz(id_scenariusz)
);
CREATE TABLE public.F_Planowane_Zapasy_Materialow (
  id_fakt bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  zapas_poczatkowy double precision,
  zapas_koncowy double precision,
  fk_id_material bigint,
  fk_id_okres bigint,
  fk_id_scenariusz bigint,
  CONSTRAINT F_Planowane_Zapasy_Materialow_pkey PRIMARY KEY (id_fakt),
  CONSTRAINT F_Planowane_Zapasy_Materialow_fk_id_material_fkey FOREIGN KEY (fk_id_material) REFERENCES public.D_Material(id_material),
  CONSTRAINT F_Planowane_Zapasy_Materialow_fk_id_okres_fkey FOREIGN KEY (fk_id_okres) REFERENCES public.D_Okres(id_okres),
  CONSTRAINT F_Planowane_Zapasy_Materialow_fk_id_scenariusz_fkey FOREIGN KEY (fk_id_scenariusz) REFERENCES public.D_Scenariusz(id_scenariusz)
);
CREATE TABLE public.F_Planowane_Zapasy_Produktow_Gotowych (
  id_fakt bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  zapas_poczatkowy bigint,
  zapas_koncowy bigint,
  fk_id_produkt bigint,
  fk_id_okres bigint,
  fk_id_scenariusz bigint,
  CONSTRAINT F_Planowane_Zapasy_Produktow_Gotowych_pkey PRIMARY KEY (id_fakt),
  CONSTRAINT F_Produkt_Plan_fk_id_produkt_fkey FOREIGN KEY (fk_id_produkt) REFERENCES public.D_Produkt(id_produkt),
  CONSTRAINT F_Produkt_Plan_fk_id_okres_fkey FOREIGN KEY (fk_id_okres) REFERENCES public.D_Okres(id_okres),
  CONSTRAINT F_Produkt_Plan_fk_id_scenariusz_fkey FOREIGN KEY (fk_id_scenariusz) REFERENCES public.D_Scenariusz(id_scenariusz)
);
CREATE TABLE public.F_Prowizja (
  id_fakt bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  prowizja_za_sztuke double precision,
  fk_id_produkt bigint,
  fk_id_okres bigint,
  fk_id_scenariusz bigint,
  CONSTRAINT F_Prowizja_pkey PRIMARY KEY (id_fakt),
  CONSTRAINT F_Prowizja_fk_id_produkt_fkey FOREIGN KEY (fk_id_produkt) REFERENCES public.D_Produkt(id_produkt),
  CONSTRAINT F_Prowizja_fk_id_scenariusz_fkey FOREIGN KEY (fk_id_scenariusz) REFERENCES public.D_Scenariusz(id_scenariusz),
  CONSTRAINT F_Prowizja_fk_id_okres_fkey FOREIGN KEY (fk_id_okres) REFERENCES public.D_Okres(id_okres)
);
CREATE TABLE public.F_Robocizna (
  id_fakt bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  robocizna_potrzebna double precision,
  fk_id_produkt bigint,
  fk_id_okres bigint,
  fk_id_scenariusz bigint,
  robocizna_1rh bigint,
  CONSTRAINT F_Robocizna_pkey PRIMARY KEY (id_fakt),
  CONSTRAINT F_Robocizna_Potrzebna_fk_id_produkt_fkey FOREIGN KEY (fk_id_produkt) REFERENCES public.D_Produkt(id_produkt),
  CONSTRAINT F_Robocizna_Potrzebna_fk_id_okres_fkey FOREIGN KEY (fk_id_okres) REFERENCES public.D_Okres(id_okres),
  CONSTRAINT F_Robocizna_Potrzebna_fk_id_scenariusz_fkey FOREIGN KEY (fk_id_scenariusz) REFERENCES public.D_Scenariusz(id_scenariusz)
);
CREATE TABLE public.F_Stale_Koszty_Wydzialu_Produkcyjnego (
  id_fakt bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  koszt double precision,
  fk_id_koszt_wydzialowy_niekontrolowany bigint,
  fk_id_okres bigint,
  fk_id_scenariusz bigint,
  CONSTRAINT F_Stale_Koszty_Wydzialu_Produkcyjnego_pkey PRIMARY KEY (id_fakt),
  CONSTRAINT F_Stale_Koszty_Wydzialu_Produ_fk_id_koszt_wydzialowy_nieko_fkey FOREIGN KEY (fk_id_koszt_wydzialowy_niekontrolowany) REFERENCES public.D_Koszty_Wydzialowe_Niekontrolowane(id_koszt_wydzialowy_niekontrolowany),
  CONSTRAINT F_Stale_Koszty_Wydzialu_Produkcyjnego_fk_id_okres_fkey FOREIGN KEY (fk_id_okres) REFERENCES public.D_Okres(id_okres),
  CONSTRAINT F_Stale_Koszty_Wydzialu_Produkcyjnego_fk_id_scenariusz_fkey FOREIGN KEY (fk_id_scenariusz) REFERENCES public.D_Scenariusz(id_scenariusz)
);
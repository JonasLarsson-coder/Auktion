--
-- PostgreSQL database dump
--

-- Dumped from database version 16.4
-- Dumped by pg_dump version 16.4

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: klockauktion; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA klockauktion;


ALTER SCHEMA klockauktion OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: adress; Type: TABLE; Schema: klockauktion; Owner: postgres
--

CREATE TABLE klockauktion.adress (
    id integer NOT NULL,
    gatunamn character varying(233),
    gatunummer character varying(233),
    ort character varying(233),
    postnummer integer,
    land character varying(233),
    personuppgifter_id integer
);


ALTER TABLE klockauktion.adress OWNER TO postgres;

--
-- Name: adress_id_seq; Type: SEQUENCE; Schema: klockauktion; Owner: postgres
--

CREATE SEQUENCE klockauktion.adress_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE klockauktion.adress_id_seq OWNER TO postgres;

--
-- Name: adress_id_seq; Type: SEQUENCE OWNED BY; Schema: klockauktion; Owner: postgres
--

ALTER SEQUENCE klockauktion.adress_id_seq OWNED BY klockauktion.adress.id;


--
-- Name: auktion; Type: TABLE; Schema: klockauktion; Owner: postgres
--

CREATE TABLE klockauktion.auktion (
    id integer NOT NULL,
    starttid date,
    sluttid date,
    start_bud integer,
    "säljare_id" integer,
    klocka_id integer
);


ALTER TABLE klockauktion.auktion OWNER TO postgres;

--
-- Name: klocka; Type: TABLE; Schema: klockauktion; Owner: postgres
--

CREATE TABLE klockauktion.klocka (
    id integer NOT NULL,
    "märke" character varying(233),
    modell character varying(233),
    diameter numeric,
    "färg" character varying(23),
    urverk character varying(233),
    armband character varying(233),
    auktion_id integer,
    beskrivning character varying(255)
);


ALTER TABLE klockauktion.klocka OWNER TO postgres;

--
-- Name: alla_auktioner_med_utgångsbud; Type: VIEW; Schema: klockauktion; Owner: postgres
--

CREATE VIEW klockauktion."alla_auktioner_med_utgångsbud" AS
 SELECT auktion.id,
    auktion.start_bud AS "utgångsbud",
    k."märke",
    k.modell,
    auktion.starttid,
    auktion.sluttid
   FROM (klockauktion.auktion
     JOIN klockauktion.klocka k ON ((auktion.klocka_id = k.id)))
  WHERE (auktion.start_bud IS NOT NULL)
  ORDER BY auktion.start_bud;


ALTER VIEW klockauktion."alla_auktioner_med_utgångsbud" OWNER TO postgres;

--
-- Name: budgivning; Type: TABLE; Schema: klockauktion; Owner: postgres
--

CREATE TABLE klockauktion.budgivning (
    id integer NOT NULL,
    bud integer,
    budgivare_id integer,
    auktion_id integer,
    "datum_för_bud" timestamp without time zone
);


ALTER TABLE klockauktion.budgivning OWNER TO postgres;

--
-- Name: konto; Type: TABLE; Schema: klockauktion; Owner: postgres
--

CREATE TABLE klockauktion.konto (
    email_id integer,
    personuppgifter_id integer,
    password character varying(255),
    admin boolean,
    nickname character varying(255),
    profilbild character varying(255),
    id integer NOT NULL
);


ALTER TABLE klockauktion.konto OWNER TO postgres;

--
-- Name: personuppgifter; Type: TABLE; Schema: klockauktion; Owner: postgres
--

CREATE TABLE klockauktion.personuppgifter (
    id integer NOT NULL,
    namn character varying(233),
    efternamn character varying(233),
    personnummer character varying(233),
    adress_id integer
);


ALTER TABLE klockauktion.personuppgifter OWNER TO postgres;

--
-- Name: anna_hajens_egna_auktioner; Type: VIEW; Schema: klockauktion; Owner: postgres
--

CREATE VIEW klockauktion.anna_hajens_egna_auktioner AS
 SELECT konto.nickname,
    p.namn,
    a."säljare_id",
    a.id AS auktions_id,
    k."märke",
    k.modell,
    b.bud
   FROM ((((klockauktion.konto
     JOIN klockauktion.auktion a ON ((konto.id = a."säljare_id")))
     JOIN klockauktion.klocka k ON ((k.id = a.klocka_id)))
     JOIN klockauktion.budgivning b ON ((a.id = b.auktion_id)))
     JOIN klockauktion.personuppgifter p ON ((p.id = konto.personuppgifter_id)))
  WHERE ((a."säljare_id" = 2) AND (b.auktion_id = 3))
  ORDER BY b.bud DESC;


ALTER VIEW klockauktion.anna_hajens_egna_auktioner OWNER TO postgres;

--
-- Name: användare_id_seq; Type: SEQUENCE; Schema: klockauktion; Owner: postgres
--

CREATE SEQUENCE klockauktion."användare_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE klockauktion."användare_id_seq" OWNER TO postgres;

--
-- Name: användare_id_seq; Type: SEQUENCE OWNED BY; Schema: klockauktion; Owner: postgres
--

ALTER SEQUENCE klockauktion."användare_id_seq" OWNED BY klockauktion.personuppgifter.id;


--
-- Name: email; Type: TABLE; Schema: klockauktion; Owner: postgres
--

CREATE TABLE klockauktion.email (
    id integer NOT NULL,
    email character varying(255),
    personuppgifter_id integer
);


ALTER TABLE klockauktion.email OWNER TO postgres;

--
-- Name: användare_kan_logga_in; Type: VIEW; Schema: klockauktion; Owner: postgres
--

CREATE VIEW klockauktion."användare_kan_logga_in" AS
 SELECT konto.nickname,
    konto.password,
    konto.email_id,
    e.email,
        CASE
            WHEN (('gegrhtryhrwg'::text = (konto.password)::text) AND ('kungen@outlook.com'::text = (e.email)::text)) THEN 'Lyckad inloggning'::text
            ELSE 'Fel email eller password'::text
        END AS "case"
   FROM (klockauktion.konto
     JOIN klockauktion.email e ON ((e.id = konto.email_id)))
  WHERE (konto.email_id = 9);


ALTER VIEW klockauktion."användare_kan_logga_in" OWNER TO postgres;

--
-- Name: auktion_id_seq; Type: SEQUENCE; Schema: klockauktion; Owner: postgres
--

CREATE SEQUENCE klockauktion.auktion_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE klockauktion.auktion_id_seq OWNER TO postgres;

--
-- Name: auktion_id_seq; Type: SEQUENCE OWNED BY; Schema: klockauktion; Owner: postgres
--

ALTER SEQUENCE klockauktion.auktion_id_seq OWNED BY klockauktion.auktion.id;


--
-- Name: avslutade_auktioner; Type: VIEW; Schema: klockauktion; Owner: postgres
--

CREATE VIEW klockauktion.avslutade_auktioner AS
 SELECT auktion.id AS auktions_id,
    auktion.sluttid,
    k."märke",
    k.modell,
    auktion.start_bud,
    max(b.bud) AS vinnande_bud
   FROM ((klockauktion.auktion
     JOIN klockauktion.klocka k ON ((auktion.klocka_id = k.id)))
     JOIN klockauktion.budgivning b ON ((auktion.id = b.auktion_id)))
  WHERE (auktion.sluttid < '2024-10-08'::date)
  GROUP BY auktion.id, auktion.sluttid, k."märke", k.modell, auktion.start_bud;


ALTER VIEW klockauktion.avslutade_auktioner OWNER TO postgres;

--
-- Name: bilder; Type: TABLE; Schema: klockauktion; Owner: postgres
--

CREATE TABLE klockauktion.bilder (
    id integer NOT NULL,
    bild character varying,
    klocka_id integer
);


ALTER TABLE klockauktion.bilder OWNER TO postgres;

--
-- Name: bilder_id_seq; Type: SEQUENCE; Schema: klockauktion; Owner: postgres
--

CREATE SEQUENCE klockauktion.bilder_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE klockauktion.bilder_id_seq OWNER TO postgres;

--
-- Name: bilder_id_seq; Type: SEQUENCE OWNED BY; Schema: klockauktion; Owner: postgres
--

ALTER SEQUENCE klockauktion.bilder_id_seq OWNED BY klockauktion.bilder.id;


--
-- Name: bud_id_seq; Type: SEQUENCE; Schema: klockauktion; Owner: postgres
--

CREATE SEQUENCE klockauktion.bud_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE klockauktion.bud_id_seq OWNER TO postgres;

--
-- Name: bud_id_seq; Type: SEQUENCE OWNED BY; Schema: klockauktion; Owner: postgres
--

ALTER SEQUENCE klockauktion.bud_id_seq OWNED BY klockauktion.budgivning.id;


--
-- Name: budhistorik_för_auktion; Type: VIEW; Schema: klockauktion; Owner: postgres
--

CREATE VIEW klockauktion."budhistorik_för_auktion" AS
 SELECT auktion.id AS auktions_id,
    p.namn,
    k.nickname,
    b.bud,
    b."datum_för_bud",
    k2."märke",
    k2.modell
   FROM ((((klockauktion.auktion
     JOIN klockauktion.budgivning b ON ((auktion.id = b.auktion_id)))
     JOIN klockauktion.konto k ON ((b.budgivare_id = k.id)))
     JOIN klockauktion.personuppgifter p ON ((k.personuppgifter_id = p.id)))
     JOIN klockauktion.klocka k2 ON ((auktion.klocka_id = k2.id)))
  WHERE (auktion.id = 3)
  ORDER BY b."datum_för_bud";


ALTER VIEW klockauktion."budhistorik_för_auktion" OWNER TO postgres;

--
-- Name: budhistorik_samt_aktuellt_bud; Type: VIEW; Schema: klockauktion; Owner: postgres
--

CREATE VIEW klockauktion.budhistorik_samt_aktuellt_bud AS
 SELECT a.id AS auktions_nummer,
    k2.nickname,
    budgivning.bud,
    budgivning."datum_för_bud",
    k."märke",
    k.modell
   FROM (((klockauktion.budgivning
     JOIN klockauktion.auktion a ON ((budgivning.auktion_id = a.id)))
     JOIN klockauktion.klocka k ON ((k.id = a.klocka_id)))
     JOIN klockauktion.konto k2 ON ((budgivning.budgivare_id = k2.id)))
  WHERE (a.id = 9)
  ORDER BY budgivning.bud DESC;


ALTER VIEW klockauktion.budhistorik_samt_aktuellt_bud OWNER TO postgres;

--
-- Name: detaljerad_auktionslista; Type: VIEW; Schema: klockauktion; Owner: postgres
--

CREATE VIEW klockauktion.detaljerad_auktionslista AS
 SELECT auktion.id,
    auktion.starttid,
    auktion.sluttid,
    auktion.start_bud,
    k."märke",
    k.modell,
    k.diameter,
    k."färg",
    k.armband,
    k.urverk
   FROM (klockauktion.auktion
     JOIN klockauktion.klocka k ON ((auktion.klocka_id = k.id)))
  ORDER BY auktion.starttid;


ALTER VIEW klockauktion.detaljerad_auktionslista OWNER TO postgres;

--
-- Name: historik_för_min_auktion; Type: VIEW; Schema: klockauktion; Owner: postgres
--

CREATE VIEW klockauktion."historik_för_min_auktion" AS
 SELECT a.id,
    a."säljare_id",
    a.starttid,
    a.sluttid,
    konto.nickname,
    p.namn,
    b.bud AS bud_i_kr,
    b."datum_för_bud",
    k."märke",
    k.modell
   FROM ((((klockauktion.konto
     JOIN klockauktion.personuppgifter p ON ((p.id = konto.personuppgifter_id)))
     JOIN klockauktion.budgivning b ON ((konto.id = b.budgivare_id)))
     JOIN klockauktion.auktion a ON ((b.auktion_id = a.id)))
     JOIN klockauktion.klocka k ON ((k.id = a.klocka_id)))
  WHERE (a."säljare_id" = 10);


ALTER VIEW klockauktion."historik_för_min_auktion" OWNER TO postgres;

--
-- Name: klocka_id_seq; Type: SEQUENCE; Schema: klockauktion; Owner: postgres
--

CREATE SEQUENCE klockauktion.klocka_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE klockauktion.klocka_id_seq OWNER TO postgres;

--
-- Name: klocka_id_seq; Type: SEQUENCE OWNED BY; Schema: klockauktion; Owner: postgres
--

ALTER SEQUENCE klockauktion.klocka_id_seq OWNED BY klockauktion.klocka.id;


--
-- Name: klocka_med_bilder; Type: VIEW; Schema: klockauktion; Owner: postgres
--

CREATE VIEW klockauktion.klocka_med_bilder AS
 SELECT bilder.klocka_id,
    bilder.bild,
    k."märke",
    k.modell
   FROM (klockauktion.bilder
     JOIN klockauktion.klocka k ON ((bilder.klocka_id = k.id)))
  WHERE (bilder.klocka_id = 8);


ALTER VIEW klockauktion.klocka_med_bilder OWNER TO postgres;

--
-- Name: konto_id_seq; Type: SEQUENCE; Schema: klockauktion; Owner: postgres
--

CREATE SEQUENCE klockauktion.konto_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE klockauktion.konto_id_seq OWNER TO postgres;

--
-- Name: konto_id_seq; Type: SEQUENCE OWNED BY; Schema: klockauktion; Owner: postgres
--

ALTER SEQUENCE klockauktion.konto_id_seq OWNED BY klockauktion.konto.id;


--
-- Name: lista_på_alla_auktioner; Type: VIEW; Schema: klockauktion; Owner: postgres
--

CREATE VIEW klockauktion."lista_på_alla_auktioner" AS
 SELECT auktion.id,
    auktion.starttid,
    auktion.sluttid,
    k."märke",
    k.modell,
    auktion.start_bud
   FROM (klockauktion.auktion
     JOIN klockauktion.klocka k ON ((auktion.klocka_id = k.id)))
  ORDER BY auktion.starttid;


ALTER VIEW klockauktion."lista_på_alla_auktioner" OWNER TO postgres;

--
-- Name: telefon; Type: TABLE; Schema: klockauktion; Owner: postgres
--

CREATE TABLE klockauktion.telefon (
    id integer NOT NULL,
    telefonnummer character varying(23),
    personuppgifter_id integer
);


ALTER TABLE klockauktion.telefon OWNER TO postgres;

--
-- Name: lista_på_användare_som_inte_är_admin; Type: VIEW; Schema: klockauktion; Owner: postgres
--

CREATE VIEW klockauktion."lista_på_användare_som_inte_är_admin" AS
 SELECT p.namn,
    p.efternamn,
    e.email,
    konto.admin,
    konto.nickname,
    konto.profilbild,
    t.telefonnummer
   FROM (((klockauktion.konto
     JOIN klockauktion.email e ON ((konto.email_id = e.id)))
     JOIN klockauktion.telefon t ON ((e.personuppgifter_id = t.personuppgifter_id)))
     JOIN klockauktion.personuppgifter p ON ((p.id = konto.personuppgifter_id)))
  WHERE (konto.admin = false);


ALTER VIEW klockauktion."lista_på_användare_som_inte_är_admin" OWNER TO postgres;

--
-- Name: lista_på_användare_som_är_admin; Type: VIEW; Schema: klockauktion; Owner: postgres
--

CREATE VIEW klockauktion."lista_på_användare_som_är_admin" AS
 SELECT p.namn,
    p.efternamn,
    e.email,
    konto.admin,
    konto.nickname,
    konto.profilbild,
    t.telefonnummer
   FROM (((klockauktion.konto
     JOIN klockauktion.email e ON ((konto.email_id = e.id)))
     JOIN klockauktion.telefon t ON ((e.personuppgifter_id = t.personuppgifter_id)))
     JOIN klockauktion.personuppgifter p ON ((p.id = konto.personuppgifter_id)))
  WHERE (konto.admin = true);


ALTER VIEW klockauktion."lista_på_användare_som_är_admin" OWNER TO postgres;

--
-- Name: lista_på_auktioner_som_snart_går_ut; Type: VIEW; Schema: klockauktion; Owner: postgres
--

CREATE VIEW klockauktion."lista_på_auktioner_som_snart_går_ut" AS
 SELECT auktion.id AS auktions_id,
    auktion.sluttid,
    k."märke",
    k.modell,
    max(b.bud) AS "högsta_bud_i_kr"
   FROM ((klockauktion.auktion
     JOIN klockauktion.klocka k ON ((auktion.klocka_id = k.id)))
     JOIN klockauktion.budgivning b ON ((auktion.id = b.auktion_id)))
  WHERE ((auktion.sluttid >= '2024-10-23'::date) AND (auktion.sluttid <= '2024-10-31'::date))
  GROUP BY auktion.id, auktion.sluttid, k."märke", k.modell;


ALTER VIEW klockauktion."lista_på_auktioner_som_snart_går_ut" OWNER TO postgres;

--
-- Name: lista_på_nya_auktioner; Type: VIEW; Schema: klockauktion; Owner: postgres
--

CREATE VIEW klockauktion."lista_på_nya_auktioner" AS
 SELECT auktion.id AS auktions_id,
    auktion.starttid,
    k."märke",
    k.modell,
    auktion.start_bud
   FROM (klockauktion.auktion
     JOIN klockauktion.klocka k ON ((auktion.klocka_id = k.id)))
  WHERE (auktion.starttid >= '2024-10-08'::date);


ALTER VIEW klockauktion."lista_på_nya_auktioner" OWNER TO postgres;

--
-- Name: mail_id_seq; Type: SEQUENCE; Schema: klockauktion; Owner: postgres
--

CREATE SEQUENCE klockauktion.mail_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE klockauktion.mail_id_seq OWNER TO postgres;

--
-- Name: mail_id_seq; Type: SEQUENCE OWNED BY; Schema: klockauktion; Owner: postgres
--

ALTER SEQUENCE klockauktion.mail_id_seq OWNED BY klockauktion.email.id;


--
-- Name: mina_egna_bud; Type: VIEW; Schema: klockauktion; Owner: postgres
--

CREATE VIEW klockauktion.mina_egna_bud AS
 SELECT auktion.id AS auktions_id,
    k.nickname,
    p.namn,
    b.bud,
    b."datum_för_bud",
    k2."märke",
    k2.modell
   FROM ((((klockauktion.auktion
     JOIN klockauktion.budgivning b ON ((auktion.id = b.auktion_id)))
     JOIN klockauktion.konto k ON ((b.budgivare_id = k.id)))
     JOIN klockauktion.personuppgifter p ON ((k.personuppgifter_id = p.id)))
     JOIN klockauktion.klocka k2 ON ((auktion.klocka_id = k2.id)))
  WHERE (((k.nickname)::text = 'tigern'::text) AND (b.auktion_id = 9))
  ORDER BY b.bud;


ALTER VIEW klockauktion.mina_egna_bud OWNER TO postgres;

--
-- Name: objektbeskrivning; Type: VIEW; Schema: klockauktion; Owner: postgres
--

CREATE VIEW klockauktion.objektbeskrivning AS
 SELECT "märke",
    modell,
    diameter,
    "färg",
    urverk,
    armband
   FROM klockauktion.klocka
  ORDER BY "märke";


ALTER VIEW klockauktion.objektbeskrivning OWNER TO postgres;

--
-- Name: pågående_auktioner; Type: VIEW; Schema: klockauktion; Owner: postgres
--

CREATE VIEW klockauktion."pågående_auktioner" AS
 SELECT auktion.id AS auktions_id,
    auktion.starttid,
    auktion.sluttid,
    k."märke",
    k.modell,
    auktion.start_bud
   FROM (klockauktion.auktion
     JOIN klockauktion.klocka k ON ((auktion.klocka_id = k.id)))
  WHERE ((auktion.starttid < '2024-10-08'::date) AND (auktion.sluttid > '2024-10-08'::date));


ALTER VIEW klockauktion."pågående_auktioner" OWNER TO postgres;

--
-- Name: sökning_specifikt_märke; Type: VIEW; Schema: klockauktion; Owner: postgres
--

CREATE VIEW klockauktion."sökning_specifikt_märke" AS
 SELECT klocka."märke",
    klocka.modell,
    a.starttid,
    a.sluttid,
    a.start_bud
   FROM (klockauktion.klocka
     JOIN klockauktion.auktion a ON ((klocka.id = a.klocka_id)))
  WHERE ((klocka."märke")::text = 'rolex'::text);


ALTER VIEW klockauktion."sökning_specifikt_märke" OWNER TO postgres;

--
-- Name: telefon_id_seq; Type: SEQUENCE; Schema: klockauktion; Owner: postgres
--

CREATE SEQUENCE klockauktion.telefon_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE klockauktion.telefon_id_seq OWNER TO postgres;

--
-- Name: telefon_id_seq; Type: SEQUENCE OWNED BY; Schema: klockauktion; Owner: postgres
--

ALTER SEQUENCE klockauktion.telefon_id_seq OWNED BY klockauktion.telefon.id;


--
-- Name: vinnade_bud_och_vem_som_vann; Type: VIEW; Schema: klockauktion; Owner: postgres
--

CREATE VIEW klockauktion.vinnade_bud_och_vem_som_vann AS
 SELECT auktion.id AS auktions_id,
    k.nickname,
    b.bud,
    b."datum_för_bud"
   FROM ((klockauktion.auktion
     JOIN klockauktion.budgivning b ON ((auktion.id = b.auktion_id)))
     JOIN klockauktion.konto k ON ((b.budgivare_id = k.id)))
  WHERE (((auktion.sluttid >= '1995-01-12'::date) AND (auktion.sluttid <= '2024-10-08'::date)) AND (b.auktion_id = 8))
  ORDER BY b.bud DESC
 LIMIT 1;


ALTER VIEW klockauktion.vinnade_bud_och_vem_som_vann OWNER TO postgres;

--
-- Name: adress id; Type: DEFAULT; Schema: klockauktion; Owner: postgres
--

ALTER TABLE ONLY klockauktion.adress ALTER COLUMN id SET DEFAULT nextval('klockauktion.adress_id_seq'::regclass);


--
-- Name: auktion id; Type: DEFAULT; Schema: klockauktion; Owner: postgres
--

ALTER TABLE ONLY klockauktion.auktion ALTER COLUMN id SET DEFAULT nextval('klockauktion.auktion_id_seq'::regclass);


--
-- Name: bilder id; Type: DEFAULT; Schema: klockauktion; Owner: postgres
--

ALTER TABLE ONLY klockauktion.bilder ALTER COLUMN id SET DEFAULT nextval('klockauktion.bilder_id_seq'::regclass);


--
-- Name: budgivning id; Type: DEFAULT; Schema: klockauktion; Owner: postgres
--

ALTER TABLE ONLY klockauktion.budgivning ALTER COLUMN id SET DEFAULT nextval('klockauktion.bud_id_seq'::regclass);


--
-- Name: email id; Type: DEFAULT; Schema: klockauktion; Owner: postgres
--

ALTER TABLE ONLY klockauktion.email ALTER COLUMN id SET DEFAULT nextval('klockauktion.mail_id_seq'::regclass);


--
-- Name: klocka id; Type: DEFAULT; Schema: klockauktion; Owner: postgres
--

ALTER TABLE ONLY klockauktion.klocka ALTER COLUMN id SET DEFAULT nextval('klockauktion.klocka_id_seq'::regclass);


--
-- Name: konto id; Type: DEFAULT; Schema: klockauktion; Owner: postgres
--

ALTER TABLE ONLY klockauktion.konto ALTER COLUMN id SET DEFAULT nextval('klockauktion.konto_id_seq'::regclass);


--
-- Name: personuppgifter id; Type: DEFAULT; Schema: klockauktion; Owner: postgres
--

ALTER TABLE ONLY klockauktion.personuppgifter ALTER COLUMN id SET DEFAULT nextval('klockauktion."användare_id_seq"'::regclass);


--
-- Name: telefon id; Type: DEFAULT; Schema: klockauktion; Owner: postgres
--

ALTER TABLE ONLY klockauktion.telefon ALTER COLUMN id SET DEFAULT nextval('klockauktion.telefon_id_seq'::regclass);


--
-- Data for Name: adress; Type: TABLE DATA; Schema: klockauktion; Owner: postgres
--

INSERT INTO klockauktion.adress (id, gatunamn, gatunummer, ort, postnummer, land, personuppgifter_id) VALUES (1, 'solvägen', '12', 'stockholm', 12345, 'sverige', 1);
INSERT INTO klockauktion.adress (id, gatunamn, gatunummer, ort, postnummer, land, personuppgifter_id) VALUES (2, 'vintergatan', '87', 'stockholm', 12387, 'sverige', 2);
INSERT INTO klockauktion.adress (id, gatunamn, gatunummer, ort, postnummer, land, personuppgifter_id) VALUES (3, 'storgatan', '45', 'göteborg', 23456, 'sverige', 3);
INSERT INTO klockauktion.adress (id, gatunamn, gatunummer, ort, postnummer, land, personuppgifter_id) VALUES (4, 'avenyn', '1', 'göteborg', 23478, 'sverige', 4);
INSERT INTO klockauktion.adress (id, gatunamn, gatunummer, ort, postnummer, land, personuppgifter_id) VALUES (5, 'hötorget', '11', 'stockholm', 12366, 'sverige', 5);
INSERT INTO klockauktion.adress (id, gatunamn, gatunummer, ort, postnummer, land, personuppgifter_id) VALUES (6, 'kungstensgatan', '7', 'göteborg', 23412, 'sverige', 6);
INSERT INTO klockauktion.adress (id, gatunamn, gatunummer, ort, postnummer, land, personuppgifter_id) VALUES (7, 'lilla_torg', '34', 'malmö', 56734, 'sverige', 7);
INSERT INTO klockauktion.adress (id, gatunamn, gatunummer, ort, postnummer, land, personuppgifter_id) VALUES (8, 'stora_torg', '73', 'malmö', 56712, 'sverige', 8);
INSERT INTO klockauktion.adress (id, gatunamn, gatunummer, ort, postnummer, land, personuppgifter_id) VALUES (9, 'gågatan', '32c', 'lund', 12789, 'sverige', 9);
INSERT INTO klockauktion.adress (id, gatunamn, gatunummer, ort, postnummer, land, personuppgifter_id) VALUES (10, 'glassvägen', '8a', 'tranås', 67855, 'sverige', 10);
INSERT INTO klockauktion.adress (id, gatunamn, gatunummer, ort, postnummer, land, personuppgifter_id) VALUES (11, 'kartgatan', '6', 'tranås', 55912, 'sverige', 11);
INSERT INTO klockauktion.adress (id, gatunamn, gatunummer, ort, postnummer, land, personuppgifter_id) VALUES (12, 'avenyn', '5', 'compton', 567832, 'usa', 12);


--
-- Data for Name: auktion; Type: TABLE DATA; Schema: klockauktion; Owner: postgres
--

INSERT INTO klockauktion.auktion (id, starttid, sluttid, start_bud, "säljare_id", klocka_id) VALUES (7, '2025-10-03', '2025-10-31', 30000, 8, 6);
INSERT INTO klockauktion.auktion (id, starttid, sluttid, start_bud, "säljare_id", klocka_id) VALUES (3, '2021-09-07', '2021-09-30', 6000, 2, 8);
INSERT INTO klockauktion.auktion (id, starttid, sluttid, start_bud, "säljare_id", klocka_id) VALUES (5, '2024-09-04', '2024-10-31', 7000, 3, 3);
INSERT INTO klockauktion.auktion (id, starttid, sluttid, start_bud, "säljare_id", klocka_id) VALUES (6, '2024-10-01', '2024-10-23', 45, 2, 5);
INSERT INTO klockauktion.auktion (id, starttid, sluttid, start_bud, "säljare_id", klocka_id) VALUES (4, '2024-10-01', '2024-10-18', 1, 4, 1);
INSERT INTO klockauktion.auktion (id, starttid, sluttid, start_bud, "säljare_id", klocka_id) VALUES (1, '2024-09-16', '2024-09-30', NULL, 1, 4);
INSERT INTO klockauktion.auktion (id, starttid, sluttid, start_bud, "säljare_id", klocka_id) VALUES (8, '2024-06-05', '2024-07-02', NULL, 10, 7);
INSERT INTO klockauktion.auktion (id, starttid, sluttid, start_bud, "säljare_id", klocka_id) VALUES (9, '2024-10-02', '2024-11-13', NULL, 12, 9);
INSERT INTO klockauktion.auktion (id, starttid, sluttid, start_bud, "säljare_id", klocka_id) VALUES (2, '2025-09-02', '2026-09-10', 200, 3, 2);


--
-- Data for Name: bilder; Type: TABLE DATA; Schema: klockauktion; Owner: postgres
--

INSERT INTO klockauktion.bilder (id, bild, klocka_id) VALUES (2, 'https://media2.uretvintage.se/images/vintage/products/968314/1/1250_001_back.jpg?dh=500&q=85&sharpen=1x1', 1);
INSERT INTO klockauktion.bilder (id, bild, klocka_id) VALUES (1, 'https://media4.uret.se/images/product-popup-o/ab/breitling-A77310101A3A1.jpg', 1);
INSERT INTO klockauktion.bilder (id, bild, klocka_id) VALUES (4, 'https://media3.uret.se/images/product-popup-o/qr/rolex-submariner-126613LN-0002_m.jpg', 2);
INSERT INTO klockauktion.bilder (id, bild, klocka_id) VALUES (3, 'https://media3.uret.se/images/product-popup-o/qr/rolex-submariner-126613LN-0002.jpg', 2);
INSERT INTO klockauktion.bilder (id, bild, klocka_id) VALUES (6, 'https://media4.uret.se/images/product-popup-o/qr/rolex-124270-0001.jpg', 3);
INSERT INTO klockauktion.bilder (id, bild, klocka_id) VALUES (5, 'https://media4.uret.se/images/product-popup-o/qr/rolex-124270-0001.jpg', 3);
INSERT INTO klockauktion.bilder (id, bild, klocka_id) VALUES (31, 'https://media4.uret.se/images/product-popup-o/st/tudor-M79030B-0001_n.jpg', 4);
INSERT INTO klockauktion.bilder (id, bild, klocka_id) VALUES (33, 'https://media4.uret.se/images/product-popup-o/st/tudor-M79030B-0001.jpg', 4);
INSERT INTO klockauktion.bilder (id, bild, klocka_id) VALUES (32, 'https://media4.uret.se/images/product-popup-o/st/tudor-M79030B-0001_k.jpg', 4);
INSERT INTO klockauktion.bilder (id, bild, klocka_id) VALUES (35, 'https://media2.uret.se/images/product-popup-o/qr/rolex-126334-0029.jpg', 5);
INSERT INTO klockauktion.bilder (id, bild, klocka_id) VALUES (34, 'https://media2.uret.se/images/product-popup-o/qr/rolex_box.jpg', 5);
INSERT INTO klockauktion.bilder (id, bild, klocka_id) VALUES (37, 'https://media4.uret.se/images/product-popup-o/st/seiko-SRPD51K1.jpg', 6);
INSERT INTO klockauktion.bilder (id, bild, klocka_id) VALUES (36, 'https://media3.uret.se/images/product-popup/st/seiko_box.jpg', 6);
INSERT INTO klockauktion.bilder (id, bild, klocka_id) VALUES (38, 'https://media3.uret.se/images/product-popup-o/st/seiko-SSK003K1.jpg', 6);
INSERT INTO klockauktion.bilder (id, bild, klocka_id) VALUES (39, 'https://media.uret.se/images/product-popup-o/st/seiko-SSC813P1.jpg', 7);
INSERT INTO klockauktion.bilder (id, bild, klocka_id) VALUES (40, 'https://media.klockgiganten.se/catalog/product/cache/8868f1f55ea9b10b8d2c7235a00bab2c/s/s/ssc813p1_3.jpg', 7);
INSERT INTO klockauktion.bilder (id, bild, klocka_id) VALUES (41, 'https://media.klockgiganten.se/catalog/product/cache/074b491b7c680a360b2429f2a25e33dc/s/s/ssc813p1_2.jpg', 7);
INSERT INTO klockauktion.bilder (id, bild, klocka_id) VALUES (42, 'https://www.stjarnurmakarna.se/pub_images/original/Seiko-SSC813P1.jpg', 7);
INSERT INTO klockauktion.bilder (id, bild, klocka_id) VALUES (44, 'https://media4.uret.se/images/product-popup-o/op/omega-210.30.42.20.03.001_k.jpg', 8);
INSERT INTO klockauktion.bilder (id, bild, klocka_id) VALUES (45, 'https://media4.uret.se/images/product-popup-o/op/omega-210.30.42.20.03.001_l.jpg', 8);
INSERT INTO klockauktion.bilder (id, bild, klocka_id) VALUES (43, 'https://media4.uret.se/images/product-popup-o/op/omega-210.30.42.20.03.001.jpg', 8);
INSERT INTO klockauktion.bilder (id, bild, klocka_id) VALUES (46, 'https://media3.uret.se/images/product-popup-o/cd/certina-C029.807.16.081.01.jpg', 9);
INSERT INTO klockauktion.bilder (id, bild, klocka_id) VALUES (47, 'https://media3.uret.se/images/product-popup-o/cd/certina_box.jpg', 9);
INSERT INTO klockauktion.bilder (id, bild, klocka_id) VALUES (48, 'https://media3.uret.se/images/product-popup-o/cd/certina_box.jpg', 10);
INSERT INTO klockauktion.bilder (id, bild, klocka_id) VALUES (49, 'https://media3.uret.se/images/product-popup-o/cd/certina-C023.727.27.051.00.jpg', 10);
INSERT INTO klockauktion.bilder (id, bild, klocka_id) VALUES (50, 'https://media3.uret.se/images/product-popup/cd/casio_box.jpg', 11);
INSERT INTO klockauktion.bilder (id, bild, klocka_id) VALUES (51, 'https://media3.uret.se/images/product-popup-o/cd/casio-MTP-1370D-1A2VDF.jpg', 11);


--
-- Data for Name: budgivning; Type: TABLE DATA; Schema: klockauktion; Owner: postgres
--

INSERT INTO klockauktion.budgivning (id, bud, budgivare_id, auktion_id, "datum_för_bud") VALUES (4, 3, 3, 1, '2024-09-17 17:33:50');
INSERT INTO klockauktion.budgivning (id, bud, budgivare_id, auktion_id, "datum_för_bud") VALUES (1, 109000, 2, 1, '2024-09-30 23:38:31');
INSERT INTO klockauktion.budgivning (id, bud, budgivare_id, auktion_id, "datum_för_bud") VALUES (2, 45000, 3, 1, '2024-09-30 14:25:51');
INSERT INTO klockauktion.budgivning (id, bud, budgivare_id, auktion_id, "datum_för_bud") VALUES (3, 67895, 2, 1, '2024-09-16 10:29:15');
INSERT INTO klockauktion.budgivning (id, bud, budgivare_id, auktion_id, "datum_för_bud") VALUES (7, 10500, 2, 3, '2024-09-09 23:34:49');
INSERT INTO klockauktion.budgivning (id, bud, budgivare_id, auktion_id, "datum_för_bud") VALUES (5, 5000, 2, 3, '2024-09-07 07:45:58');
INSERT INTO klockauktion.budgivning (id, bud, budgivare_id, auktion_id, "datum_för_bud") VALUES (6, 8000, 1, 3, '2024-09-07 15:32:43');
INSERT INTO klockauktion.budgivning (id, bud, budgivare_id, auktion_id, "datum_för_bud") VALUES (8, 45000, 1, 3, '2024-09-13 08:39:12');
INSERT INTO klockauktion.budgivning (id, bud, budgivare_id, auktion_id, "datum_för_bud") VALUES (9, 156000, 10, 3, '2024-09-30 19:34:05');
INSERT INTO klockauktion.budgivning (id, bud, budgivare_id, auktion_id, "datum_för_bud") VALUES (20, 60000, 1, 8, '2024-06-10 12:38:50');
INSERT INTO klockauktion.budgivning (id, bud, budgivare_id, auktion_id, "datum_för_bud") VALUES (19, 52000, 4, 8, '2024-06-08 12:38:33');
INSERT INTO klockauktion.budgivning (id, bud, budgivare_id, auktion_id, "datum_för_bud") VALUES (17, 23000, 4, 8, '2024-06-06 10:37:18');
INSERT INTO klockauktion.budgivning (id, bud, budgivare_id, auktion_id, "datum_för_bud") VALUES (18, 50000, 9, 8, '2024-06-08 10:37:42');
INSERT INTO klockauktion.budgivning (id, bud, budgivare_id, auktion_id, "datum_för_bud") VALUES (21, 89000, 2, 8, '2024-07-02 23:35:40');
INSERT INTO klockauktion.budgivning (id, bud, budgivare_id, auktion_id, "datum_för_bud") VALUES (16, 7000, 10, 8, '2024-06-05 23:36:50');
INSERT INTO klockauktion.budgivning (id, bud, budgivare_id, auktion_id, "datum_för_bud") VALUES (14, 75323, 3, 4, '2024-10-09 14:41:32');
INSERT INTO klockauktion.budgivning (id, bud, budgivare_id, auktion_id, "datum_för_bud") VALUES (15, 200000, 2, 4, '2024-10-18 10:40:10');
INSERT INTO klockauktion.budgivning (id, bud, budgivare_id, auktion_id, "datum_för_bud") VALUES (10, 23456, 2, 4, '2024-10-02 09:40:56');
INSERT INTO klockauktion.budgivning (id, bud, budgivare_id, auktion_id, "datum_för_bud") VALUES (13, 46788, 1, 4, '2024-10-05 08:41:20');
INSERT INTO klockauktion.budgivning (id, bud, budgivare_id, auktion_id, "datum_för_bud") VALUES (12, 87546, 3, 4, '2024-10-14 16:41:44');
INSERT INTO klockauktion.budgivning (id, bud, budgivare_id, auktion_id, "datum_för_bud") VALUES (11, 34255, 1, 4, '2024-10-02 10:39:46');
INSERT INTO klockauktion.budgivning (id, bud, budgivare_id, auktion_id, "datum_för_bud") VALUES (22, 12000, 7, 5, '2024-09-04 07:04:00');
INSERT INTO klockauktion.budgivning (id, bud, budgivare_id, auktion_id, "datum_för_bud") VALUES (23, 12600, 8, 5, '2024-09-04 10:46:42');
INSERT INTO klockauktion.budgivning (id, bud, budgivare_id, auktion_id, "datum_för_bud") VALUES (24, 15000, 9, 5, '2024-09-06 14:47:14');
INSERT INTO klockauktion.budgivning (id, bud, budgivare_id, auktion_id, "datum_för_bud") VALUES (25, 20000, 10, 5, '2024-09-07 13:47:40');
INSERT INTO klockauktion.budgivning (id, bud, budgivare_id, auktion_id, "datum_för_bud") VALUES (26, 21000, 7, 5, '2024-09-07 19:48:35');
INSERT INTO klockauktion.budgivning (id, bud, budgivare_id, auktion_id, "datum_för_bud") VALUES (27, 25000, 8, 5, '2024-09-07 19:49:02');
INSERT INTO klockauktion.budgivning (id, bud, budgivare_id, auktion_id, "datum_för_bud") VALUES (28, 34000, 9, 5, '2024-09-09 16:49:23');
INSERT INTO klockauktion.budgivning (id, bud, budgivare_id, auktion_id, "datum_för_bud") VALUES (29, 34500, 10, 5, '2024-09-09 17:49:46');
INSERT INTO klockauktion.budgivning (id, bud, budgivare_id, auktion_id, "datum_för_bud") VALUES (30, 50000, 7, 5, '2024-09-10 13:50:20');
INSERT INTO klockauktion.budgivning (id, bud, budgivare_id, auktion_id, "datum_för_bud") VALUES (31, 78000, 8, 5, '2024-09-30 20:50:57');
INSERT INTO klockauktion.budgivning (id, bud, budgivare_id, auktion_id, "datum_för_bud") VALUES (32, 98600, 9, 5, '2024-09-30 23:51:22');
INSERT INTO klockauktion.budgivning (id, bud, budgivare_id, auktion_id, "datum_för_bud") VALUES (33, 46, 3, 6, '2024-10-01 12:56:13');
INSERT INTO klockauktion.budgivning (id, bud, budgivare_id, auktion_id, "datum_för_bud") VALUES (34, 78, 4, 6, '2024-10-02 12:56:50');
INSERT INTO klockauktion.budgivning (id, bud, budgivare_id, auktion_id, "datum_för_bud") VALUES (35, 100, 9, 6, '2024-10-02 10:57:01');
INSERT INTO klockauktion.budgivning (id, bud, budgivare_id, auktion_id, "datum_för_bud") VALUES (36, 300, 2, 6, '2024-10-03 12:58:02');
INSERT INTO klockauktion.budgivning (id, bud, budgivare_id, auktion_id, "datum_för_bud") VALUES (37, 500, 3, 6, '2024-10-03 14:58:40');
INSERT INTO klockauktion.budgivning (id, bud, budgivare_id, auktion_id, "datum_för_bud") VALUES (38, 600, 4, 6, '2024-10-03 18:58:48');
INSERT INTO klockauktion.budgivning (id, bud, budgivare_id, auktion_id, "datum_för_bud") VALUES (39, 1000, 3, 6, '2024-10-05 11:59:29');
INSERT INTO klockauktion.budgivning (id, bud, budgivare_id, auktion_id, "datum_för_bud") VALUES (40, 3000, 4, 6, '2024-10-05 17:59:36');
INSERT INTO klockauktion.budgivning (id, bud, budgivare_id, auktion_id, "datum_för_bud") VALUES (41, 8000, 9, 6, '2024-10-06 14:59:41');
INSERT INTO klockauktion.budgivning (id, bud, budgivare_id, auktion_id, "datum_för_bud") VALUES (42, 10000, 4, 6, '2024-10-11 09:04:17');
INSERT INTO klockauktion.budgivning (id, bud, budgivare_id, auktion_id, "datum_för_bud") VALUES (43, 13000, 9, 6, '2024-10-12 11:04:10');
INSERT INTO klockauktion.budgivning (id, bud, budgivare_id, auktion_id, "datum_för_bud") VALUES (44, 17000, 3, 6, '2024-10-14 09:03:59');
INSERT INTO klockauktion.budgivning (id, bud, budgivare_id, auktion_id, "datum_för_bud") VALUES (45, 20000, 9, 6, '2024-10-14 18:02:49');
INSERT INTO klockauktion.budgivning (id, bud, budgivare_id, auktion_id, "datum_för_bud") VALUES (46, 24000, 4, 6, '2024-10-16 06:03:40');
INSERT INTO klockauktion.budgivning (id, bud, budgivare_id, auktion_id, "datum_för_bud") VALUES (47, 30000, 3, 6, '2024-10-23 07:03:29');
INSERT INTO klockauktion.budgivning (id, bud, budgivare_id, auktion_id, "datum_för_bud") VALUES (49, 70000, 3, 6, '2024-10-23 23:05:10');
INSERT INTO klockauktion.budgivning (id, bud, budgivare_id, auktion_id, "datum_för_bud") VALUES (48, 65000, 4, 6, '2024-10-23 17:03:10');
INSERT INTO klockauktion.budgivning (id, bud, budgivare_id, auktion_id, "datum_för_bud") VALUES (51, 80000, 1, 4, '2024-10-09 23:24:28');
INSERT INTO klockauktion.budgivning (id, bud, budgivare_id, auktion_id, "datum_för_bud") VALUES (50, 86000, 3, 4, '2024-10-09 23:58:23');
INSERT INTO klockauktion.budgivning (id, bud, budgivare_id, auktion_id, "datum_för_bud") VALUES (52, 666, 11, 9, '2024-10-02 10:38:00');
INSERT INTO klockauktion.budgivning (id, bud, budgivare_id, auktion_id, "datum_för_bud") VALUES (53, 1200, 8, 9, '2024-10-02 06:39:37');
INSERT INTO klockauktion.budgivning (id, bud, budgivare_id, auktion_id, "datum_för_bud") VALUES (54, 2400, 6, 9, '2024-10-02 20:34:59');
INSERT INTO klockauktion.budgivning (id, bud, budgivare_id, auktion_id, "datum_för_bud") VALUES (55, 2500, 11, 9, '2024-10-04 14:41:13');
INSERT INTO klockauktion.budgivning (id, bud, budgivare_id, auktion_id, "datum_för_bud") VALUES (56, 3400, 4, 9, '2024-10-04 14:42:42');
INSERT INTO klockauktion.budgivning (id, bud, budgivare_id, auktion_id, "datum_för_bud") VALUES (57, 5600, 8, 9, '2024-10-04 20:41:08');
INSERT INTO klockauktion.budgivning (id, bud, budgivare_id, auktion_id, "datum_för_bud") VALUES (58, 6500, 4, 9, '2024-10-09 18:45:38');
INSERT INTO klockauktion.budgivning (id, bud, budgivare_id, auktion_id, "datum_för_bud") VALUES (59, 8400, 5, 9, '2024-10-09 22:49:03');
INSERT INTO klockauktion.budgivning (id, bud, budgivare_id, auktion_id, "datum_för_bud") VALUES (60, 9040, 6, 9, '2024-10-09 11:43:04');
INSERT INTO klockauktion.budgivning (id, bud, budgivare_id, auktion_id, "datum_för_bud") VALUES (61, 10000, 8, 9, '2024-10-11 16:45:07');
INSERT INTO klockauktion.budgivning (id, bud, budgivare_id, auktion_id, "datum_för_bud") VALUES (62, 13000, 4, 9, '2024-10-11 12:46:45');
INSERT INTO klockauktion.budgivning (id, bud, budgivare_id, auktion_id, "datum_för_bud") VALUES (63, 16000, 11, 9, '2024-10-12 05:47:46');
INSERT INTO klockauktion.budgivning (id, bud, budgivare_id, auktion_id, "datum_för_bud") VALUES (64, 18000, 8, 9, '2024-11-09 23:48:07');
INSERT INTO klockauktion.budgivning (id, bud, budgivare_id, auktion_id, "datum_för_bud") VALUES (65, 20000, 4, 9, '2024-10-11 15:49:01');
INSERT INTO klockauktion.budgivning (id, bud, budgivare_id, auktion_id, "datum_för_bud") VALUES (66, 56000, 5, 9, '2024-11-13 23:49:53');
INSERT INTO klockauktion.budgivning (id, bud, budgivare_id, auktion_id, "datum_för_bud") VALUES (68, 80000, 8, 7, '2024-11-05 00:00:00');
INSERT INTO klockauktion.budgivning (id, bud, budgivare_id, auktion_id, "datum_för_bud") VALUES (69, 80000, 8, 7, '2024-11-05 00:00:00');


--
-- Data for Name: email; Type: TABLE DATA; Schema: klockauktion; Owner: postgres
--

INSERT INTO klockauktion.email (id, email, personuppgifter_id) VALUES (1, 'abc@hotmail.com', 1);
INSERT INTO klockauktion.email (id, email, personuppgifter_id) VALUES (2, 'gurka@gmail.com', 2);
INSERT INTO klockauktion.email (id, email, personuppgifter_id) VALUES (3, 'penna@gmail.com', 3);
INSERT INTO klockauktion.email (id, email, personuppgifter_id) VALUES (4, 'vasskniv@hotmail.com', 4);
INSERT INTO klockauktion.email (id, email, personuppgifter_id) VALUES (5, 'apple@outlook.com', 5);
INSERT INTO klockauktion.email (id, email, personuppgifter_id) VALUES (6, 'windows@outlook.com', 6);
INSERT INTO klockauktion.email (id, email, personuppgifter_id) VALUES (7, 'urkul@hotmail.com', 7);
INSERT INTO klockauktion.email (id, email, personuppgifter_id) VALUES (8, 'svea@hotmail.com', 8);
INSERT INTO klockauktion.email (id, email, personuppgifter_id) VALUES (9, 'kungen@outlook.com', 9);
INSERT INTO klockauktion.email (id, email, personuppgifter_id) VALUES (10, 'moppen165@gmail.com', 10);
INSERT INTO klockauktion.email (id, email, personuppgifter_id) VALUES (11, 'helikopter4@hotmail.com', 11);
INSERT INTO klockauktion.email (id, email, personuppgifter_id) VALUES (12, 'polisen@outlook.com', 12);


--
-- Data for Name: klocka; Type: TABLE DATA; Schema: klockauktion; Owner: postgres
--

INSERT INTO klockauktion.klocka (id, "märke", modell, diameter, "färg", urverk, armband, auktion_id, beskrivning) VALUES (2, 'rolex', 'submariner', 41, 'svart', 'automatisk', 'stål', 2, 'Dykarnas dykare! använd ett fåtaöl gånger.');
INSERT INTO klockauktion.klocka (id, "märke", modell, diameter, "färg", urverk, armband, auktion_id, beskrivning) VALUES (8, 'omega', 'seamaster', 42, 'blå', 'automatisk', 'stål', NULL, 'Omgegas flaggskepp. Använd ett fåtal gånger och är i nyskick.');
INSERT INTO klockauktion.klocka (id, "märke", modell, diameter, "färg", urverk, armband, auktion_id, beskrivning) VALUES (6, 'seiko', '5_sport', 42.5, 'blå', 'automatisk', 'stål', 3, 'nyligen servad och trycktesstaad. Spår av användning finns.');
INSERT INTO klockauktion.klocka (id, "märke", modell, diameter, "färg", urverk, armband, auktion_id, beskrivning) VALUES (7, 'seiko', 'prospex_speedtimer', 39, 'vit', 'automatisk', 'stål', NULL, 'Går utmärkt, +1spd, spår av användning finns');
INSERT INTO klockauktion.klocka (id, "märke", modell, diameter, "färg", urverk, armband, auktion_id, beskrivning) VALUES (10, 'certina', 'ds_eagle', 46, 'svart', 'automatisk', 'gummi', NULL, 'För den som har lite grövre handleder är denna klocka perfekt.');
INSERT INTO klockauktion.klocka (id, "märke", modell, diameter, "färg", urverk, armband, auktion_id, beskrivning) VALUES (5, 'rolex', 'datejust', 41, 'grön', 'automatisk', 'stål', 4, 'klassisk dressklocka med en gångreserv pupp till 70 timmar.');
INSERT INTO klockauktion.klocka (id, "märke", modell, diameter, "färg", urverk, armband, auktion_id, beskrivning) VALUES (4, 'tudor', 'black_bay', 39, 'blå', 'automatisk', 'stål', 1, 'En klocka som passar till allt. Finns spår av användnig.');
INSERT INTO klockauktion.klocka (id, "märke", modell, diameter, "färg", urverk, armband, auktion_id, beskrivning) VALUES (3, 'rolex', 'explorer', 36, 'svart', 'automatisk', 'stål', NULL, 'Svart urtavla med självlysande markeringar arabiska siffror och indexmarkeringar');
INSERT INTO klockauktion.klocka (id, "märke", modell, diameter, "färg", urverk, armband, auktion_id, beskrivning) VALUES (1, 'breitling', 'chronomat_32', 32, 'vit', 'automatisk', 'stål', NULL, 'Servad hos AD 2023, +2spd, Omgegas flaggskepp. Använd ett fåtal gånger och är i nyskick.');
INSERT INTO klockauktion.klocka (id, "märke", modell, diameter, "färg", urverk, armband, auktion_id, beskrivning) VALUES (9, 'certina', 'ds_1', 40, 'grå', 'quartz', 'läder', NULL, 'Använde ett fåtal gånger. Bezel i borstat stål.');
INSERT INTO klockauktion.klocka (id, "märke", modell, diameter, "färg", urverk, armband, auktion_id, beskrivning) VALUES (11, 'casio', 'quartz', 39.8, 'svart', 'quartz', 'stål', NULL, 'Mineralglas, finns spår av användning. nytt batteri.');


--
-- Data for Name: konto; Type: TABLE DATA; Schema: klockauktion; Owner: postgres
--

INSERT INTO klockauktion.konto (email_id, personuppgifter_id, password, admin, nickname, profilbild, id) VALUES (7, 7, 'adg4576856h', true, 'hönan', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcShx42ytAr5uS20GToruOroYSK1hTeHo1LUig&s', 1);
INSERT INTO klockauktion.konto (email_id, personuppgifter_id, password, admin, nickname, profilbild, id) VALUES (4, 4, 'fadsfcdgerag', false, 'pandan', 'https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcSkE3_jt77nos0xRJJ_yymWO68-3Ab9pjxrsRiMPseM6y1IRI84', 7);
INSERT INTO klockauktion.konto (email_id, personuppgifter_id, password, admin, nickname, profilbild, id) VALUES (3, 3, 'fdfge5t23466', false, 'flodhästen', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSPj8CP44uCZMhvkEFX_t8As2DvyHgLkLSi7Q&s', 5);
INSERT INTO klockauktion.konto (email_id, personuppgifter_id, password, admin, nickname, profilbild, id) VALUES (2, 2, '4r435fergrth', false, 'elefanten', 'https://vilddjur.se/wp-content/uploads/sites/560/2019/10/ds6rQDfDTLvP.jpg', 9);
INSERT INTO klockauktion.konto (email_id, personuppgifter_id, password, admin, nickname, profilbild, id) VALUES (10, 10, 'ertaf32355fe', false, 'fisken', 'https://svd.vgc.no/v2/images/2a8ae42e-d5a8-4523-95cc-31e6cc35801d?fit=crop&h=551&q=80&upscale=true&w=980&s=17cbc0548a13e41c0420d139bf211ced166d6492', 11);
INSERT INTO klockauktion.konto (email_id, personuppgifter_id, password, admin, nickname, profilbild, id) VALUES (9, 9, 'gegrhtryhrwg', false, 'hajen', 'https://media.arto.se/app/uploads/sites/6/2021/11/08123451/1456px-Tiger_shark.jpg?auto=format&crop=faces&facepad=10&fit=crop&q=50&w=1060&h=706', 2);
INSERT INTO klockauktion.konto (email_id, personuppgifter_id, password, admin, nickname, profilbild, id) VALUES (5, 5, '123456789bhh', false, 'apan', 'https://media.arto.se/app/uploads/sites/6/2019/10/08124628/Scheinsaffe2.jpg?auto=format&crop=faces&facepad=10&fit=crop&q=50&w=1060&h=706', 4);
INSERT INTO klockauktion.konto (email_id, personuppgifter_id, password, admin, nickname, profilbild, id) VALUES (11, 11, 'nhfgjjytut56', false, 'tigern', 'https://upload.wikimedia.org/wikipedia/commons/4/41/Siberischer_tiger_de_edit02.jpg', 8);
INSERT INTO klockauktion.konto (email_id, personuppgifter_id, password, admin, nickname, profilbild, id) VALUES (12, 12, 'ertfergjsr45', false, 'myggan', 'https://www.artdatabanken.se/globalassets/ew/subw/artd/4-arter-och-natur/dagens-natur/host-2023/slu-artdatabanken-aedes-cyprius-foto-anders-lindstrom.jpg', 10);
INSERT INTO klockauktion.konto (email_id, personuppgifter_id, password, admin, nickname, profilbild, id) VALUES (1, 1, '4etrfdzrgbjj', false, 'ankan', 'https://cdn.starwebserver.se/shops/miwex/files/csm_badeente-027xxl-seite-2018_f97266c717_1.png', 6);
INSERT INTO klockauktion.konto (email_id, personuppgifter_id, password, admin, nickname, profilbild, id) VALUES (6, 6, 'q4353tg50g5f', false, 'gåsen', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS4sWQLVL6zfmrmaBXqpPNcNFPNESbS49dJsw&s', 3);
INSERT INTO klockauktion.konto (email_id, personuppgifter_id, password, admin, nickname, profilbild, id) VALUES (8, 8, 'ertgewrgvssd', false, 'kycklingen', 'https://img.koket.se/standard-mega/grillad-kyckling.jpg', 12);


--
-- Data for Name: personuppgifter; Type: TABLE DATA; Schema: klockauktion; Owner: postgres
--

INSERT INTO klockauktion.personuppgifter (id, namn, efternamn, personnummer, adress_id) VALUES (12, 'lily', 'larsson', '810924-7723', 12);
INSERT INTO klockauktion.personuppgifter (id, namn, efternamn, personnummer, adress_id) VALUES (9, 'Anna', 'fredsson', '920922-6722', 9);
INSERT INTO klockauktion.personuppgifter (id, namn, efternamn, personnummer, adress_id) VALUES (7, 'linus', 'lindroth', '830327-2349', 7);
INSERT INTO klockauktion.personuppgifter (id, namn, efternamn, personnummer, adress_id) VALUES (5, 'alex ', 'axelsson', '851011-9888', 5);
INSERT INTO klockauktion.personuppgifter (id, namn, efternamn, personnummer, adress_id) VALUES (2, 'leo', 'nilsson', '850612-2312', 2);
INSERT INTO klockauktion.personuppgifter (id, namn, efternamn, personnummer, adress_id) VALUES (1, 'jonas', 'larsson', '850220-1234', 1);
INSERT INTO klockauktion.personuppgifter (id, namn, efternamn, personnummer, adress_id) VALUES (11, 'jonas', 'svensson', '850919-9087', 11);
INSERT INTO klockauktion.personuppgifter (id, namn, efternamn, personnummer, adress_id) VALUES (6, 'gustav', 'dahlberg', '840819-4489', 6);
INSERT INTO klockauktion.personuppgifter (id, namn, efternamn, personnummer, adress_id) VALUES (4, 'emil', 'salon', '850417-4432', 4);
INSERT INTO klockauktion.personuppgifter (id, namn, efternamn, personnummer, adress_id) VALUES (3, 'petter', 'asperholm', '850709-5643', 3);
INSERT INTO klockauktion.personuppgifter (id, namn, efternamn, personnummer, adress_id) VALUES (10, 'roffe', 'ruff', '820119-8828', 10);
INSERT INTO klockauktion.personuppgifter (id, namn, efternamn, personnummer, adress_id) VALUES (8, 'lisa', 'nilsson', '930512-5532', 8);


--
-- Data for Name: telefon; Type: TABLE DATA; Schema: klockauktion; Owner: postgres
--

INSERT INTO klockauktion.telefon (id, telefonnummer, personuppgifter_id) VALUES (1, '0704690282', 1);
INSERT INTO klockauktion.telefon (id, telefonnummer, personuppgifter_id) VALUES (2, '0739456754', 2);
INSERT INTO klockauktion.telefon (id, telefonnummer, personuppgifter_id) VALUES (3, '0704821232', 3);
INSERT INTO klockauktion.telefon (id, telefonnummer, personuppgifter_id) VALUES (4, '0739774519', 4);
INSERT INTO klockauktion.telefon (id, telefonnummer, personuppgifter_id) VALUES (5, '0739112243', 5);
INSERT INTO klockauktion.telefon (id, telefonnummer, personuppgifter_id) VALUES (6, '0739067654', 6);
INSERT INTO klockauktion.telefon (id, telefonnummer, personuppgifter_id) VALUES (7, '0739987854', 7);
INSERT INTO klockauktion.telefon (id, telefonnummer, personuppgifter_id) VALUES (8, '0704431278', 8);
INSERT INTO klockauktion.telefon (id, telefonnummer, personuppgifter_id) VALUES (9, '0704567809', 9);
INSERT INTO klockauktion.telefon (id, telefonnummer, personuppgifter_id) VALUES (10, '0739126754', 10);
INSERT INTO klockauktion.telefon (id, telefonnummer, personuppgifter_id) VALUES (11, '0739124387', 11);
INSERT INTO klockauktion.telefon (id, telefonnummer, personuppgifter_id) VALUES (12, '0765234127', 12);


--
-- Name: adress_id_seq; Type: SEQUENCE SET; Schema: klockauktion; Owner: postgres
--

SELECT pg_catalog.setval('klockauktion.adress_id_seq', 12, true);


--
-- Name: användare_id_seq; Type: SEQUENCE SET; Schema: klockauktion; Owner: postgres
--

SELECT pg_catalog.setval('klockauktion."användare_id_seq"', 12, true);


--
-- Name: auktion_id_seq; Type: SEQUENCE SET; Schema: klockauktion; Owner: postgres
--

SELECT pg_catalog.setval('klockauktion.auktion_id_seq', 9, true);


--
-- Name: bilder_id_seq; Type: SEQUENCE SET; Schema: klockauktion; Owner: postgres
--

SELECT pg_catalog.setval('klockauktion.bilder_id_seq', 53, true);


--
-- Name: bud_id_seq; Type: SEQUENCE SET; Schema: klockauktion; Owner: postgres
--

SELECT pg_catalog.setval('klockauktion.bud_id_seq', 66, true);


--
-- Name: klocka_id_seq; Type: SEQUENCE SET; Schema: klockauktion; Owner: postgres
--

SELECT pg_catalog.setval('klockauktion.klocka_id_seq', 11, true);


--
-- Name: konto_id_seq; Type: SEQUENCE SET; Schema: klockauktion; Owner: postgres
--

SELECT pg_catalog.setval('klockauktion.konto_id_seq', 12, true);


--
-- Name: mail_id_seq; Type: SEQUENCE SET; Schema: klockauktion; Owner: postgres
--

SELECT pg_catalog.setval('klockauktion.mail_id_seq', 12, true);


--
-- Name: telefon_id_seq; Type: SEQUENCE SET; Schema: klockauktion; Owner: postgres
--

SELECT pg_catalog.setval('klockauktion.telefon_id_seq', 12, true);


--
-- Name: adress adress_pk; Type: CONSTRAINT; Schema: klockauktion; Owner: postgres
--

ALTER TABLE ONLY klockauktion.adress
    ADD CONSTRAINT adress_pk PRIMARY KEY (id);


--
-- Name: auktion auktion_pk; Type: CONSTRAINT; Schema: klockauktion; Owner: postgres
--

ALTER TABLE ONLY klockauktion.auktion
    ADD CONSTRAINT auktion_pk PRIMARY KEY (id);


--
-- Name: bilder bilder_pk; Type: CONSTRAINT; Schema: klockauktion; Owner: postgres
--

ALTER TABLE ONLY klockauktion.bilder
    ADD CONSTRAINT bilder_pk PRIMARY KEY (id);


--
-- Name: budgivning budgivning_pk; Type: CONSTRAINT; Schema: klockauktion; Owner: postgres
--

ALTER TABLE ONLY klockauktion.budgivning
    ADD CONSTRAINT budgivning_pk PRIMARY KEY (id);


--
-- Name: email email_pk; Type: CONSTRAINT; Schema: klockauktion; Owner: postgres
--

ALTER TABLE ONLY klockauktion.email
    ADD CONSTRAINT email_pk PRIMARY KEY (id);


--
-- Name: klocka klocka_pk; Type: CONSTRAINT; Schema: klockauktion; Owner: postgres
--

ALTER TABLE ONLY klockauktion.klocka
    ADD CONSTRAINT klocka_pk PRIMARY KEY (id);


--
-- Name: konto konto_pk; Type: CONSTRAINT; Schema: klockauktion; Owner: postgres
--

ALTER TABLE ONLY klockauktion.konto
    ADD CONSTRAINT konto_pk PRIMARY KEY (id);


--
-- Name: personuppgifter personuppgifter_pk; Type: CONSTRAINT; Schema: klockauktion; Owner: postgres
--

ALTER TABLE ONLY klockauktion.personuppgifter
    ADD CONSTRAINT personuppgifter_pk PRIMARY KEY (id);


--
-- Name: telefon telefon_pk; Type: CONSTRAINT; Schema: klockauktion; Owner: postgres
--

ALTER TABLE ONLY klockauktion.telefon
    ADD CONSTRAINT telefon_pk PRIMARY KEY (id);


--
-- Name: adress adress_personuppgifter_id_fk; Type: FK CONSTRAINT; Schema: klockauktion; Owner: postgres
--

ALTER TABLE ONLY klockauktion.adress
    ADD CONSTRAINT adress_personuppgifter_id_fk FOREIGN KEY (personuppgifter_id) REFERENCES klockauktion.personuppgifter(id);


--
-- Name: auktion auktion_klocka_id_fk; Type: FK CONSTRAINT; Schema: klockauktion; Owner: postgres
--

ALTER TABLE ONLY klockauktion.auktion
    ADD CONSTRAINT auktion_klocka_id_fk FOREIGN KEY (klocka_id) REFERENCES klockauktion.klocka(id);


--
-- Name: auktion auktion_konto_id_fk; Type: FK CONSTRAINT; Schema: klockauktion; Owner: postgres
--

ALTER TABLE ONLY klockauktion.auktion
    ADD CONSTRAINT auktion_konto_id_fk FOREIGN KEY ("säljare_id") REFERENCES klockauktion.konto(id);


--
-- Name: bilder bilder_klocka_id_fk; Type: FK CONSTRAINT; Schema: klockauktion; Owner: postgres
--

ALTER TABLE ONLY klockauktion.bilder
    ADD CONSTRAINT bilder_klocka_id_fk FOREIGN KEY (klocka_id) REFERENCES klockauktion.klocka(id);


--
-- Name: budgivning budgivning_auktion_id_fk; Type: FK CONSTRAINT; Schema: klockauktion; Owner: postgres
--

ALTER TABLE ONLY klockauktion.budgivning
    ADD CONSTRAINT budgivning_auktion_id_fk FOREIGN KEY (auktion_id) REFERENCES klockauktion.auktion(id);


--
-- Name: budgivning budgivning_konto_id_fk; Type: FK CONSTRAINT; Schema: klockauktion; Owner: postgres
--

ALTER TABLE ONLY klockauktion.budgivning
    ADD CONSTRAINT budgivning_konto_id_fk FOREIGN KEY (budgivare_id) REFERENCES klockauktion.konto(id);


--
-- Name: email email_personuppgifter_id_fk; Type: FK CONSTRAINT; Schema: klockauktion; Owner: postgres
--

ALTER TABLE ONLY klockauktion.email
    ADD CONSTRAINT email_personuppgifter_id_fk FOREIGN KEY (personuppgifter_id) REFERENCES klockauktion.personuppgifter(id);


--
-- Name: klocka klocka_auktion_id_fk; Type: FK CONSTRAINT; Schema: klockauktion; Owner: postgres
--

ALTER TABLE ONLY klockauktion.klocka
    ADD CONSTRAINT klocka_auktion_id_fk FOREIGN KEY (auktion_id) REFERENCES klockauktion.auktion(id);


--
-- Name: konto konto_mail_id_fk; Type: FK CONSTRAINT; Schema: klockauktion; Owner: postgres
--

ALTER TABLE ONLY klockauktion.konto
    ADD CONSTRAINT konto_mail_id_fk FOREIGN KEY (email_id) REFERENCES klockauktion.email(id);


--
-- Name: konto konto_personuppgifter_id_fk; Type: FK CONSTRAINT; Schema: klockauktion; Owner: postgres
--

ALTER TABLE ONLY klockauktion.konto
    ADD CONSTRAINT konto_personuppgifter_id_fk FOREIGN KEY (personuppgifter_id) REFERENCES klockauktion.personuppgifter(id);


--
-- Name: personuppgifter personuppgifter_adress_id_fk; Type: FK CONSTRAINT; Schema: klockauktion; Owner: postgres
--

ALTER TABLE ONLY klockauktion.personuppgifter
    ADD CONSTRAINT personuppgifter_adress_id_fk FOREIGN KEY (adress_id) REFERENCES klockauktion.adress(id);


--
-- Name: telefon telefon_personuppgifter_id_fk; Type: FK CONSTRAINT; Schema: klockauktion; Owner: postgres
--

ALTER TABLE ONLY klockauktion.telefon
    ADD CONSTRAINT telefon_personuppgifter_id_fk FOREIGN KEY (personuppgifter_id) REFERENCES klockauktion.personuppgifter(id);


--
-- PostgreSQL database dump complete
--


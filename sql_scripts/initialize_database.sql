
--- kao user SYSTEM ili SYS kreiramo tablespace i admin usera ---
CREATE TABLESPACE SIROL2 LOGGING
  DATAFILE 'C:\oraclexe\app\oracle\oradata\XE\SIROL2.ora'
  SIZE 100M REUSE AUTOEXTEND ON NEXT 10M MAXSIZE UNLIMITED
  EXTENT MANAGEMENT LOCAL
/

CREATE USER student IDENTIFIED BY student
   DEFAULT TABLESPACE SIROL2
/

-- ***** Prava na vlastitoj shemi *****
GRANT ALTER SESSION TO student;
GRANT CREATE DATABASE LINK TO student;
GRANT CREATE PROCEDURE TO student;
GRANT CREATE SEQUENCE TO student;
GRANT CREATE SESSION  TO student;
GRANT CREATE SYNONYM TO student;
GRANT CREATE TABLE TO student;
GRANT CREATE TRIGGER TO student;
GRANT CREATE TYPE TO student;
GRANT CREATE VIEW TO student;
GRANT CREATE USER TO student;
GRANT CREATE ROLE TO student;

ALTER USER student QUOTA UNLIMITED ON SIROL2;


/*========= TABLICE ============*/

CREATE TABLE M_DOBAVLJACI(
    id number(20) not null,
    sifra varchar2(10) not null,
    naziv varchar2(40) not null,
    naziv_duzi varchar2(100),
    adresa varchar2(50)not null,
    user_dodavanja varchar2(30) not null,
    datum_dodavanja date not null,
    user_izmjene varchar2(30) not null,
    datum_izmjene date not null,
    CONSTRAINT m_dobavljaci_pk PRIMARY KEY(id),
    CONSTRAINT m_dobavljaci_sifra_uk UNIQUE(sifra),
    CONSTRAINT m_dobavljaci_naziv_uk UNIQUE(naziv)
);

CREATE TABLE M_MT (
    id number(20) not null,
    sifra varchar2(10) not null,
    naziv varchar2(40) not null,
    naziv_duzi varchar2(100),
    user_dodavanja varchar2(30) not null,
    datum_dodavanja date not null,
    user_izmjene varchar2(30) not null,
    datum_izmjene date not null,
    CONSTRAINT m_mt_pk PRIMARY KEY(id),
    CONSTRAINT m_mt_sifra_uk UNIQUE(sifra),
    CONSTRAINT m_mt_naziv_uk UNIQUE(naziv)
);

CREATE TABLE M_SIROVINE(
    id number(20) not null,
    sifra varchar2(10) not null,
    naziv varchar2(40) not null,
    naziv_duzi varchar2(100),
    oznaka_potvrde varchar2(1) not null,
    user_dodavanja varchar2(30) not null,
    datum_dodavanja date not null,
    user_izmjene varchar2(30) not null,
    datum_izmjene date not null,
    CONSTRAINT m_sirovine_pk PRIMARY KEY(id),
    CONSTRAINT m_sirovine_sifra_uk UNIQUE(sifra),
    CONSTRAINT m_sirovine_naziv_uk UNIQUE(naziv),
    CONSTRAINT m_sirovine_oznaka_check CHECK(oznaka_potvrde = 'D' OR oznaka_potvrde = 'N')
);

CREATE TABLE M_NAMIRNICE(
    id number(20) not null,
    sifra varchar2(10) not null,
    naziv varchar2(40) not null,
    naziv_duzi varchar2(100),
    user_dodavanja varchar2(30) not null,
    datum_dodavanja date not null,
    user_izmjene varchar2(30) not null,
    datum_izmjene date not null,
    CONSTRAINT m_namirnice_pk PRIMARY KEY(id),
    CONSTRAINT m_namirnice_sifra_uk UNIQUE(sifra),
    CONSTRAINT m_namirnice_naziv_uk UNIQUE(naziv)
);

CREATE TABLE M_RASTAV_SIROVINA(
    id number(20) not null,
    id_sirovine number(20) not null,
    id_namirnice number(20) not null,
    udio number(5,2) not null,
    user_dodavanja varchar2(30) not null,
    datum_dodavanja date not null,
    user_izmjene varchar2(30) not null,
    datum_izmjene date not null,
    CONSTRAINT m_rastav_sirovina_pk PRIMARY KEY(id),
    CONSTRAINT m_rastav_sirovina_sir_fk FOREIGN KEY (id_sirovine) REFERENCES M_SIROVINE(ID),
    CONSTRAINT m_rastav_sirovina_nam_fk FOREIGN KEY (id_namirnice) REFERENCES M_NAMIRNICE(ID),
    CONSTRAINT m_rastav_sirovina_sir_nam_uk UNIQUE (id_sirovine, id_namirnice),
    CONSTRAINT m_rastav_sirovina_udio_check CHECK(udio > 0 AND udio <= 100)
);

CREATE INDEX  m_rastav_sirovina_sir_i ON M_RASTAV_SIROVINA(id_sirovine);
CREATE INDEX  m_rastav_sirovina_nam_i ON M_RASTAV_SIROVINA(id_namirnice);

CREATE TABLE T_PRIMKE_ZAG(
    id number(20) not null,
    id_dobavljaci number(20) not null,
    id_mt number(20) not null,
    broj varchar2(10) not null,
    datum_isporuke date not null,
    datum_zaprimanja date not null,
    opis varchar2(40) not null,
    opis_duzi varchar2(100),
    oznaka_potvrde varchar2(1) not null,
    user_dodavanja varchar2(30) not null,
    datum_dodavanja date not null,
    user_izmjene varchar2(30) not null,
    datum_izmjene date not null,
    CONSTRAINT t_primke_zag_pk PRIMARY KEY(id),
    CONSTRAINT t_primke_zag_broj_uk UNIQUE(broj),
    CONSTRAINT t_primke_zag_dob_fk FOREIGN KEY(id_dobavljaci) REFERENCES M_DOBAVLJACI(ID),
    CONSTRAINT t_primke_zag_mt_fk FOREIGN KEY(id_mt) REFERENCES M_MT(ID),
    CONSTRAINT t_primke_zag_datum_check CHECK(datum_isporuke <= datum_zaprimanja),
    CONSTRAINT t_primke_zag_oznaka_check CHECK(oznaka_potvrde = 'D' OR oznaka_potvrde = 'N')
);

CREATE INDEX  primke_zag_dob_i ON T_PRIMKE_ZAG(id_dobavljaci);
CREATE INDEX  primke_zag_mt_i ON T_PRIMKE_ZAG(id_mt);

CREATE TABLE T_PRIMKE_STA(
    id number(20) not null,
    id_primke number(20) not null,
    id_sirovine number(20) not null,
    kolicina number(12,2) not null,
    nabavna_cijena number(10,2) not null,
    user_dodavanja varchar2(30) not null,
    datum_dodavanja date not null,
    user_izmjene varchar2(30) not null,
    datum_izmjene date not null,
    CONSTRAINT t_primke_sta_pk PRIMARY KEY(id),
    CONSTRAINT t_primke_sta_prim_zag_fk FOREIGN KEY (id_primke) REFERENCES T_PRIMKE_ZAG(ID),
    CONSTRAINT t_primke_sta_sir_fk FOREIGN KEY (id_sirovine) REFERENCES M_SIROVINE(ID),
    CONSTRAINT t_primke_sta_prim_sir_uk UNIQUE(id_primke, id_sirovine),
    CONSTRAINT t_primke_sta_kol_check CHECK(kolicina > 0)
);

CREATE INDEX  primke_sta_zag_prim_i ON T_PRIMKE_STA(id_primke);
CREATE INDEX  primke_sta_sir_i ON T_PRIMKE_STA(id_sirovine);

CREATE TABLE I_ULAZ_NAMIRNICA(
    id number(20) not null,
    datum date not null,
    id_mt number(20) not null,
    id_namirnice number(20) not null,
    kolicina number(12,2) not null,
    user_dodavanja varchar2(30) not null,
    datum_dodavanja date not null,
    user_izmjene varchar2(30) not null,
    datum_izmjene date not null,
    CONSTRAINT i_ulaz_namirnica_pk PRIMARY KEY(id),
    CONSTRAINT i_ulaz_namirnica_mt_fk FOREIGN KEY (id_mt) REFERENCES M_MT(ID),
    CONSTRAINT i_ulaz_namirnica_nam_fk FOREIGN KEY (id_namirnice) REFERENCES M_NAMIRNICE(ID),
    CONSTRAINT i_ulaz_namirnica_dat_mt_nam_uk UNIQUE(datum, id_mt, id_namirnice)
);

CREATE INDEX  ulaz_namirnica_mt_i ON I_ULAZ_NAMIRNICA(id_mt);
CREATE INDEX  ulaz_namirnica_nam_i ON I_ULAZ_NAMIRNICA(id_namirnice);


/*========= SEKVENCA ============*/

CREATE SEQUENCE sekvenca_za_id
/


/*========= POMOĆNI PAKET ZA AŽURIRANJE AUDIT POLJA ============*/

CREATE OR REPLACE PACKAGE pomocni_pak IS
  FUNCTION sekvenca (id_p NUMBER) RETURN NUMBER;

  PROCEDURE upisi_audit_polja (
    user_dodavanja_p  IN OUT VARCHAR2,
    datum_dodavanja_p IN OUT DATE,
    user_izmjene_p    IN OUT VARCHAR2,
    datum_izmjene_p   IN OUT DATE);
END;
/

CREATE OR REPLACE PACKAGE BODY pomocni_pak IS
  FUNCTION sekvenca (id_p NUMBER) RETURN NUMBER
  IS
    id_l NUMBER;
  BEGIN

    IF id_p IS NOT NULL THEN
      id_l := id_p;
    ELSE
      SELECT sekvenca_za_id.NEXTVAL INTO id_l FROM DUAL;
    END IF;

    RETURN id_l;
  END;

  PROCEDURE upisi_audit_polja (
    user_dodavanja_p  IN OUT VARCHAR2,
    datum_dodavanja_p IN OUT DATE,
    user_izmjene_p    IN OUT VARCHAR2,
    datum_izmjene_p   IN OUT DATE)
  IS
  BEGIN

    IF user_dodavanja_p IS NULL THEN
      user_dodavanja_p  := USER;
      datum_dodavanja_p := SYSDATE;
    END IF;

    user_izmjene_p  := USER;
    datum_izmjene_p := SYSDATE;
  END;
END;
/


/*========= TRIGGERI ============*/

CREATE OR REPLACE TRIGGER BIR_M_DOBAVLJACI
  BEFORE INSERT ON M_DOBAVLJACI
  FOR EACH ROW
BEGIN
  :NEW.id := pomocni_pak.sekvenca (:NEW.id);

  pomocni_pak.upisi_audit_polja (
    :NEW.user_dodavanja,
    :NEW.datum_dodavanja,
    :NEW.user_izmjene,
    :NEW.datum_izmjene);
END;
/

CREATE OR REPLACE TRIGGER BUR_M_DOBAVLJACI
  BEFORE UPDATE ON M_DOBAVLJACI
  FOR EACH ROW
BEGIN
  pomocni_pak.upisi_audit_polja (
    :NEW.user_dodavanja,
    :NEW.datum_dodavanja,
    :NEW.user_izmjene,
    :NEW.datum_izmjene);
END;
/

CREATE OR REPLACE TRIGGER BIR_M_MT
  BEFORE INSERT ON M_MT
  FOR EACH ROW
BEGIN
  :NEW.id := pomocni_pak.sekvenca (:NEW.id);

  pomocni_pak.upisi_audit_polja (
    :NEW.user_dodavanja,
    :NEW.datum_dodavanja,
    :NEW.user_izmjene,
    :NEW.datum_izmjene);
END;
/

CREATE OR REPLACE TRIGGER BUR_M_MT
  BEFORE UPDATE ON M_MT
  FOR EACH ROW
BEGIN
  pomocni_pak.upisi_audit_polja (
    :NEW.user_dodavanja,
    :NEW.datum_dodavanja,
    :NEW.user_izmjene,
    :NEW.datum_izmjene);
END;
/

CREATE OR REPLACE TRIGGER BIR_M_SIROVINE
  BEFORE INSERT ON M_SIROVINE
  FOR EACH ROW
BEGIN
  :NEW.id := pomocni_pak.sekvenca (:NEW.id);

  pomocni_pak.upisi_audit_polja (
    :NEW.user_dodavanja,
    :NEW.datum_dodavanja,
    :NEW.user_izmjene,
    :NEW.datum_izmjene);
END;
/

CREATE OR REPLACE TRIGGER BUR_M_SIROVINE
  BEFORE UPDATE ON M_SIROVINE
  FOR EACH ROW
BEGIN
  pomocni_pak.upisi_audit_polja (
    :NEW.user_dodavanja,
    :NEW.datum_dodavanja,
    :NEW.user_izmjene,
    :NEW.datum_izmjene);
END;
/

CREATE OR REPLACE TRIGGER BIR_M_NAMIRNICE
  BEFORE INSERT ON M_NAMIRNICE
  FOR EACH ROW
BEGIN
  :NEW.id := pomocni_pak.sekvenca (:NEW.id);

  pomocni_pak.upisi_audit_polja (
    :NEW.user_dodavanja,
    :NEW.datum_dodavanja,
    :NEW.user_izmjene,
    :NEW.datum_izmjene);
END;
/

CREATE OR REPLACE TRIGGER BUR_M_NAMIRNICE
  BEFORE UPDATE ON M_NAMIRNICE
  FOR EACH ROW
BEGIN
  pomocni_pak.upisi_audit_polja (
    :NEW.user_dodavanja,
    :NEW.datum_dodavanja,
    :NEW.user_izmjene,
    :NEW.datum_izmjene);
END;
/

CREATE OR REPLACE TRIGGER BIR_M_RASTAV_SIROVINA
  BEFORE INSERT ON M_RASTAV_SIROVINA
  FOR EACH ROW
BEGIN
  :NEW.id := pomocni_pak.sekvenca (:NEW.id);

  pomocni_pak.upisi_audit_polja (
    :NEW.user_dodavanja,
    :NEW.datum_dodavanja,
    :NEW.user_izmjene,
    :NEW.datum_izmjene);
END;
/

CREATE OR REPLACE TRIGGER BUR_M_RASTAV_SIROVINA
  BEFORE UPDATE ON M_RASTAV_SIROVINA
  FOR EACH ROW
BEGIN
  pomocni_pak.upisi_audit_polja (
    :NEW.user_dodavanja,
    :NEW.datum_dodavanja,
    :NEW.user_izmjene,
    :NEW.datum_izmjene);
END;
/

CREATE OR REPLACE TRIGGER BIR_T_PRIMKE_ZAG
  BEFORE INSERT ON T_PRIMKE_ZAG
  FOR EACH ROW
BEGIN
  :NEW.id := pomocni_pak.sekvenca (:NEW.id);

  pomocni_pak.upisi_audit_polja (
    :NEW.user_dodavanja,
    :NEW.datum_dodavanja,
    :NEW.user_izmjene,
    :NEW.datum_izmjene);
END;
/

CREATE OR REPLACE TRIGGER BUR_T_PRIMKE_ZAG
  BEFORE UPDATE ON T_PRIMKE_ZAG
  FOR EACH ROW
BEGIN
  pomocni_pak.upisi_audit_polja (
    :NEW.user_dodavanja,
    :NEW.datum_dodavanja,
    :NEW.user_izmjene,
    :NEW.datum_izmjene);
END;
/

CREATE OR REPLACE TRIGGER BIR_T_PRIMKE_STA
  BEFORE INSERT ON T_PRIMKE_STA
  FOR EACH ROW
BEGIN
  :NEW.id := pomocni_pak.sekvenca (:NEW.id);

  pomocni_pak.upisi_audit_polja (
    :NEW.user_dodavanja,
    :NEW.datum_dodavanja,
    :NEW.user_izmjene,
    :NEW.datum_izmjene);
END;
/

CREATE OR REPLACE TRIGGER BUR_T_PRIMKE_STA
  BEFORE UPDATE ON T_PRIMKE_STA
  FOR EACH ROW
BEGIN
  pomocni_pak.upisi_audit_polja (
    :NEW.user_dodavanja,
    :NEW.datum_dodavanja,
    :NEW.user_izmjene,
    :NEW.datum_izmjene);
END;
/

CREATE OR REPLACE TRIGGER BIR_I_ULAZ_NAMIRNICA
  BEFORE INSERT ON I_ULAZ_NAMIRNICA
  FOR EACH ROW
BEGIN
  :NEW.id := pomocni_pak.sekvenca (:NEW.id);

  pomocni_pak.upisi_audit_polja (
    :NEW.user_dodavanja,
    :NEW.datum_dodavanja,
    :NEW.user_izmjene,
    :NEW.datum_izmjene);
END;
/

CREATE OR REPLACE TRIGGER BUR_I_ULAZ_NAMIRNICA
  BEFORE UPDATE ON I_ULAZ_NAMIRNICA
  FOR EACH ROW
BEGIN
  pomocni_pak.upisi_audit_polja (
    :NEW.user_dodavanja,
    :NEW.datum_dodavanja,
    :NEW.user_izmjene,
    :NEW.datum_izmjene);
END;
/


/*=========== PAKET SA PROCEDURAMA KOJE AŽURIRAJU ZALIHE I PROVJERAVAJU UDIO U SIROVINAMA =================*/

CREATE OR REPLACE PACKAGE sirovine_paket IS

  PROCEDURE provjeri_udio_sirovine (
      p_id  IN NUMBER);

  PROCEDURE obracunaj_zalihu_nakon_primke (
      p_id  IN NUMBER,
      p_mt IN NUMBER,
      p_datum_zaprimanja IN DATE);

END;
/

CREATE OR REPLACE PACKAGE BODY sirovine_paket IS

    PROCEDURE provjeri_udio_sirovine (
        p_id  IN NUMBER) IS

        l_ukupni_udio number(5,2);
     BEGIN
          SELECT SUM(udio)
            INTO l_ukupni_udio
            FROM m_rastav_sirovina
            WHERE id_sirovine  = p_id;

          IF(l_ukupni_udio < 100 OR l_ukupni_udio > 100 OR l_ukupni_udio IS NULL) THEN
            RAISE_APPLICATION_ERROR(-20010,'Sastav sirovine nije 100%');
          END IF;
     END;


    PROCEDURE obracunaj_zalihu_nakon_primke (
    p_id  IN NUMBER,
    p_mt IN NUMBER,
    p_datum_zaprimanja IN DATE) IS

     l_postoji number(1);
     BEGIN
        FOR redak IN (SELECT p.id_sirovine as id_sirovine, p.kolicina as kolicina,
                                r.id_namirnice as id_namirnice, r.udio as udio
                          FROM T_PRIMKE_STA p, m_rastav_sirovina r
                          WHERE r.id_sirovine = p.id_sirovine
                             AND id_primke = p_id)
              LOOP

                SELECT COUNT(*)
                  INTO l_postoji
                  FROM i_ulaz_namirnica
                  WHERE id_mt = p_mt
                  AND id_namirnice = redak.id_namirnice
                  AND datum = p_datum_zaprimanja;

                IF l_postoji > 0 THEN -- Namirnica postoji u ulazu namirnica

                   UPDATE i_ulaz_namirnica
                      SET kolicina = (kolicina +  redak.kolicina * redak.udio / 100 )
                      WHERE id_mt = p_mt
                      AND id_namirnice = redak.id_namirnice
                      AND datum = p_datum_zaprimanja;

                ELSE -- Namirnica ne postoji u ulazu namirnica

                   INSERT INTO i_ulaz_namirnica(datum, id_mt, id_namirnice, kolicina)
                          VALUES (p_datum_zaprimanja, p_mt, redak.id_namirnice, redak.kolicina * redak.udio / 100 );

                END IF;

            END LOOP;
      END;
END;
/


/*======== TRIGGERI KOJI POZIVAJU PROCEDURE ZA OBRAČUN ZALIHE NAKON PRIMKE I PROVJERE UDJELA NAMIRNICA U SIROVINI ==========*/

CREATE OR REPLACE TRIGGER AUR_M_SIROVINE
AFTER UPDATE ON M_SIROVINE
FOR EACH ROW

BEGIN
     IF ((:OLD.oznaka_potvrde = 'N') AND (:NEW.oznaka_potvrde = 'D')) THEN
         sirovine_paket.provjeri_udio_sirovine(:OLD.id);
     END IF;
END;
/


CREATE OR REPLACE TRIGGER AUR_T_PRIMKE_ZAG
AFTER UPDATE ON T_PRIMKE_ZAG
FOR EACH ROW

BEGIN
     IF ((:OLD.oznaka_potvrde = 'N') AND (:NEW.oznaka_potvrde = 'D')) THEN
          sirovine_paket.obracunaj_zalihu_nakon_primke(:OLD.id,:OLD.id_mt,:OLD.datum_zaprimanja);
    END IF;
END;
/


/*====== TESTNI PODACI ========*/

INSERT INTO M_DOBAVLJACI(sifra,naziv,naziv_duzi,adresa) VALUES('D1','Dob1','Dobavljac 1', 'Zagrebačka 30, Pula');
INSERT INTO M_DOBAVLJACI(sifra,naziv,naziv_duzi,adresa) VALUES('D2','Dob2','Dobavljac 2', 'Čižan 2B, Pula');


INSERT INTO M_MT(sifra,naziv,naziv_duzi) VALUES ('M1','Pula','Mjesto troška, Pula');
INSERT INTO M_MT(sifra,naziv,naziv_duzi) VALUES ('M2','Rijeka','Mjesto troška, Rijeka');


INSERT INTO M_SIROVINE(sifra,naziv,naziv_duzi,oznaka_potvrde) VALUES ('S1','čokoladna torta','Mala čokoladna torta','N');
INSERT INTO M_SIROVINE(sifra,naziv,naziv_duzi,oznaka_potvrde) VALUES ('S2','Tiramisu','Srednji tiramisu','N');


INSERT INTO M_NAMIRNICE(sifra,naziv) VALUES ('N1','čokolada');
INSERT INTO M_NAMIRNICE(sifra,naziv) VALUES ('N2','Biskvit');
INSERT INTO M_NAMIRNICE(sifra,naziv) VALUES ('N3','Krema');
INSERT INTO M_NAMIRNICE(sifra,naziv) VALUES ('N4','šlag');


INSERT INTO M_RASTAV_SIROVINA(id_sirovine,id_namirnice,udio) VALUES (5, 7, 10);
INSERT INTO M_RASTAV_SIROVINA(id_sirovine,id_namirnice,udio) VALUES (5, 8, 40);
INSERT INTO M_RASTAV_SIROVINA(id_sirovine,id_namirnice,udio) VALUES (5, 9, 40);
INSERT INTO M_RASTAV_SIROVINA(id_sirovine,id_namirnice,udio) VALUES (5, 10, 10);
UPDATE M_SIROVINE SET oznaka_potvrde = 'D' WHERE id = 5;


INSERT INTO M_RASTAV_SIROVINA(id_sirovine,id_namirnice,udio) VALUES (6, 7, 35);
INSERT INTO M_RASTAV_SIROVINA(id_sirovine,id_namirnice,udio) VALUES (6, 8, 35);
INSERT INTO M_RASTAV_SIROVINA(id_sirovine,id_namirnice,udio) VALUES (6, 9, 30);
UPDATE M_SIROVINE SET oznaka_potvrde = 'D' WHERE id = 6;



INSERT INTO T_PRIMKE_ZAG(id_dobavljaci,id_mt,broj,datum_isporuke,datum_zaprimanja,opis,opis_duzi,oznaka_potvrde)
       VALUES (1,3,'12345','12.01.17','04.03.17','primka 1','','N');

INSERT INTO T_PRIMKE_STA(id_primke,id_sirovine,kolicina,nabavna_cijena) VALUES(18, 5, 500, 200);
INSERT INTO T_PRIMKE_STA(id_primke,id_sirovine,kolicina,nabavna_cijena) VALUES(18, 6, 200, 150);

UPDATE T_PRIMKE_ZAG SET oznaka_potvrde = 'D' WHERE id = 18;




INSERT INTO T_PRIMKE_ZAG(id_dobavljaci,id_mt,broj,datum_isporuke,datum_zaprimanja,opis,opis_duzi,oznaka_potvrde)
       VALUES (2,4,'12346','19.3.17','04.04.17','primka 2','opis primke 2','N');

INSERT INTO T_PRIMKE_STA(id_primke,id_sirovine,kolicina,nabavna_cijena) VALUES(25, 5, 200, 190);
INSERT INTO T_PRIMKE_STA(id_primke,id_sirovine,kolicina,nabavna_cijena) VALUES(25, 6, 100, 160);

UPDATE T_PRIMKE_ZAG SET oznaka_potvrde = 'D' WHERE id = 25;



INSERT INTO T_PRIMKE_ZAG(id_dobavljaci,id_mt,broj,datum_isporuke,datum_zaprimanja,opis,opis_duzi,oznaka_potvrde)
       VALUES (2,4,'12347','29.3.17','04.04.17','primka 3','opis primke 3','N');

INSERT INTO T_PRIMKE_STA(id_primke,id_sirovine,kolicina,nabavna_cijena) VALUES(32, 5, 100, 200);
INSERT INTO T_PRIMKE_STA(id_primke,id_sirovine,kolicina,nabavna_cijena) VALUES(32, 6, 80, 150);

UPDATE T_PRIMKE_ZAG SET oznaka_potvrde = 'D' WHERE id = 32;

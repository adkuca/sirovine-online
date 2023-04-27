SELECT * FROM T_PRIMKE_ZAG;
SELECT * FROM M_SIROVINE;
SELECT * FROM T_PRIMKE_STA;

INSERT INTO T_PRIMKE_ZAG(id_dobavljaci,id_mt,broj,datum_isporuke,datum_zaprimanja,opis,opis_duzi,oznaka_potvrde) 
       VALUES (1,3,'12345','12.JAN.17','04.MAR.17','primka 1','','N');
INSERT INTO T_PRIMKE_STA(id_primke,id_sirovine,kolicina,nabavna_cijena) VALUES(21, 5, 500, 200);
INSERT INTO T_PRIMKE_STA(id_primke,id_sirovine,kolicina,nabavna_cijena) VALUES(21, 6, 200, 150);
UPDATE T_PRIMKE_ZAG SET oznaka_potvrde = 'D' WHERE id = 21;
INSERT INTO T_PRIMKE_ZAG(id_dobavljaci,id_mt,broj,datum_isporuke,datum_zaprimanja,opis,opis_duzi,oznaka_potvrde) 
       VALUES (2,4,'12346','19.MAR.17','04.APR.17','primka 2','opis primke 2','N');
INSERT INTO T_PRIMKE_STA(id_primke,id_sirovine,kolicina,nabavna_cijena) VALUES(29, 5, 200, 190);
INSERT INTO T_PRIMKE_STA(id_primke,id_sirovine,kolicina,nabavna_cijena) VALUES(29, 6, 100, 160);
UPDATE T_PRIMKE_ZAG SET oznaka_potvrde = 'D' WHERE id = 29;
INSERT INTO T_PRIMKE_ZAG(id_dobavljaci,id_mt,broj,datum_isporuke,datum_zaprimanja,opis,opis_duzi,oznaka_potvrde) 
       VALUES (2,4,'12347','29.MAR.17','04.APR.17','primka 3','opis primke 3','N');
INSERT INTO T_PRIMKE_STA(id_primke,id_sirovine,kolicina,nabavna_cijena) VALUES(37, 5, 100, 200);
INSERT INTO T_PRIMKE_STA(id_primke,id_sirovine,kolicina,nabavna_cijena) VALUES(37, 6, 80, 150);
UPDATE T_PRIMKE_ZAG SET oznaka_potvrde = 'D' WHERE id = 37;  
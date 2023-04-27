CREATE OR REPLACE VIEW v_t_primke_sta (
   id,
   id_primke,
   kolicina,
   nabavna_cijena,
   user_dodavanja,
   datum_dodavanja,
   user_izmjene,
   datum_izmjene,
   id_sirovine,
   sifra_sirovine,
   naziv_sirovine)
AS
SELECT ps.id,
       ps.id_primke,
       ps.kolicina,
       ps.nabavna_cijena,
       ps.user_dodavanja,
       ps.datum_dodavanja,
       ps.user_izmjene,
       ps.datum_izmjene,
       ps.id_sirovine,
       sir.sifra,
       sir.naziv
  FROM t_primke_sta ps,
       m_sirovine sir
 WHERE ps.id_sirovine = sir.id
/
CREATE OR REPLACE VIEW v_m_rastav_sirovina_nam (
   id,
   id_sirovine,
   udio,
   user_dodavanja,
   datum_dodavanja,
   user_izmjene,
   datum_izmjene,
   id_namirnice,
   sifra_namirnice,
   naziv_namirnice)
AS
SELECT rast.id,
       rast.id_sirovine,
       rast.udio,
       rast.user_dodavanja,
       rast.datum_dodavanja,
       rast.user_izmjene,
       rast.datum_izmjene,
       rast.id_namirnice,
       nam.sifra,
       nam.naziv
  FROM m_rastav_sirovina rast,
       m_namirnice       nam
 WHERE rast.id_namirnice = nam.id
/